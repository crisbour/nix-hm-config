{ config, lib, pkgs, ... }:
#let
#  # Alternatively: https://github.com/MOIS3Y/NVDF/blob/005f184a80d89cc098b421ee0fd6e483dc269351/home/stepan/VoidOS/pkgs/nixgl.nix#L38
#  # Why we need this: https://alternativebit.fr/posts/nixos/nix-opengl-and-ubuntu-integration-nightmare/
#  #alacritty-wrapped = import ../../nixGL/nixGLWrapper.nix {
#  #  inherit pkgs;
#  #  targetPkg = pkgs.alacri;
#  #  name = "alacritty";
#  #};
#  alacritty-wrapped = with pkgs; stdenv.mkDerivation {
#    pname = alacritty.pname;
#    version = alacritty.version;
#
#    src = "${alacritty}";
#
#    buildInputs = [ alacritty ];
#
#    installPhase = ''
#      mkdir $out
#      ln -s ${alacritty}/* $out
#      rm $out/bin
#      mkdir $out/bin
#      for bin in ${alacritty}/bin/*; do
#       wrapped_bin=$out/bin/$(basename $bin)
#       echo "exec ${lib.getExe nixgl.auto.nixGLDefault} $bin \$@" > $wrapped_bin
#       chmod +x $wrapped_bin
#      done
#    '';
#    meta = alacritty.meta;
#  };
#in
let
  # TODO: Remove trace after moving alacritty-theme to flake-inputs successfully
  #theme = builtins.trace (lib.debug.traceSeqN 1 pkgs.alacritty-theme) pkgs.alacritty-theme.gruvbox_dark;
  theme = pkgs.alacritty-theme.gruvbox_dark;
in
{
  programs.alacritty = {
    package = pkgs.unstable.alacritty;
    enable = true;
    settings = {
      import = [ theme ];

      font =
      let
        fontStyle = style: {
          family = "Iosevka Nerd Font";
          inherit style;
        };
      in
      {
        size = 14;
        normal      = fontStyle "Regular";
        bold        = fontStyle "Bold";
        italic      = fontStyle "Italic";
        bold_italic = fontStyle "Bold Italic";
      };

      cursor = {
        style = "Beam";
        thickness = 0.2;
      };

      live_config_reload = true;

      window = {
        dimensions = {
          columns = 140;
          lines = 40;
        };
        decorations = "None";
      };

      shell = if config.programs.tmux.enable
      then {
        program = config.home.sessionVariables.SHELL;
        args = ["-c" "tmux attach || tmux new"];
      } else {
        program = config.home.sessionVariables.SHELL;
      };


      # TODO: Improve fonts configs like https://github.com/oceanlewis/nix-config/blob/e692821d3d3f77785131737707e4ce723cc68f72/programs/alacritty/fonts.nix#L61
    };
  };
}
