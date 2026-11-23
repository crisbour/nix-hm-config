{ inputs, lib, pkgs, config, outputs, ... }:
with lib.hm.gvariant;
let
  editor   = "nvim";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  shell    = "${pkgs.zsh}/bin/zsh";
in
{
  imports = [
    ./stylix.nix
    ../features/cli
    ../features/neovim
  ] ++ (builtins.attrValues outputs.homeModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      # TODO Are there packages that I would like and are not in nixpkgs
      permittedInsecurePackages = [
        "electron-41.10.7"
        "tmate-unstable-2022-08-07"
      ];
      #packagesOverrides = pkgs: {
      #  nur = import (builtins.fetchTarball
      #    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      #      inherit pkgs;
      #    };
      #};
      # TODO: Is this necessary?
      xdg = { configHome = homeDirectory; };
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      max-jobs = "auto";
      cores = 0;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      trusted-users = [ config.home.username ];
      # Use `blazer` as nix-store cache
      substituters = [
        "http://w9098.hyena.royal.ts.net:5000"
      ];
      trusted-public-keys = [
        "w9098.hyena-royal.ts.net:INWavQ8uSBgahDSv/KWISqjTZhCtCrsddQRrxJvRPy4="
      ];
      #access-tokens = {
      #  "github.com" = builtins.getEnv "GITHUB_TOKEN";
      #};
      #netrc-file = "${homeDirectory}/config/nix/netrc";
    };
  };

  # A systemd unit switcher for Home Manager => (re)start service when changing config
  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "26.05";
    #sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      # FIX: Set FLAKE path at the user setup?
      #FLAKE = "$HOME/Documents/Scripts/Linux/nix-hm-config";
      NIX_BUILD_SHELL = "${shell}";
      COLORTERM = "truecolor";
      VISUAL    = "${editor}";
      EDITOR    = "${editor}";
      SHELL     = "${shell}";
      TERMINAL  = "${terminal}";
      #SSH_AUTH_SOCK = lib.mkForce "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
      NIXPKGS_ALLOW_UNFREE = "1";
      CUPS_USER = "s2703496";
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Allow Nix to handle fonts
  fonts.fontconfig.enable = true;

  # Alternative to plain direnv, add watch method to evaluate state of shell
  services.lorri.enable = true;

  services.udiskie.enable = true;

  # TODO: Still more to improve: https://github.com/Misterio77/nix-config/blob/main/home/misterio/global/default.nix
}
