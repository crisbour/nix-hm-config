{ config, pkgs, lib, ... }:
let
  cfg = config.services.pix2tex;
in {
  options.services.pix2tex = {
    enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc "Whether to install pix2tex, an image to LaTeX converter using deep learning.";
      example = lib.literalExpression "true";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (callPackage stdenv.mkDerivation {
        name = "pix2tex";
        src = pkgs.writeShellScriptBin "pix2tex" ''
          ${pkgs.grimblast}/bin/grimblast save area /tmp/pix2tex_screenshot.png && ${pkgs.curl}/bin/curl -s -X POST -F "file=@/tmp/pix2tex_screenshot.png" -L http://127.0.0.1:8502/predict | ${pkgs.jq}/bin/jq -r | ${pkgs.wl-clipboard}/bin/wl-copy
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp $src/bin/pix2tex $out/bin/pix2tex
          chmod +x $out/bin/pix2tex
        '';
      })
    ];

    #virtualisation.oci-containers.containers.pix2tex = {
    #  image = "lukasblecher/pix2tex";
    #  ports = ["8502:8502"];
    #};
    home.file.".config/systemd/user/pix2tex.service".text = ''
      [Unit]
      Description=Pix2Tex Container
      After=network.target

      [Service]
      ExecStart=${pkgs.podman}/bin/podman run --rm --name pix2tex -p 8502:8502 lukasblecher/pix2tex
      ExecStop=${pkgs.podman}/bin/podman stop -t 10 pix2tex
      Restart=always

      [Install]
      WantedBy=default.target
    '';

    #systemd.user.services.pix2tex = {
    #  wantedBy = [ "default.target" ];
    #  #after = [ "graphical-session.target" ];
    #  serviceConfig = {
    #    ExecStart = "podman run --rm --name pix2tex -p 8502:8502 lukasblecher/pix2tex";
    #    ExecStop = "podman stop -t 10 pix2tex";
    #    Restart = "always";
    #  };
    #};
  };
}
