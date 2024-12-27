{ inputs, lib, pkgs, config, outputs, ... }:
with lib.hm.gvariant;
let
  editor   = "nvim";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  shell    = "${pkgs.zsh}/bin/zsh";
in
{
  imports = [
    ../features/cli
    ../features/neovim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      # TODO Are there packages that I would like and are not in nixpkgs
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
      experimental-features = [ "nix-command" "flakes" ];
      # TODO Add: "configurable-impure-env" "auto-allocate-uids"
      warn-dirty = false;
      # NOTE: Do we need explicit use of store cache
      #substituters = "https://cache.nixos.org";
      #trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    };
  };

  # A systemd unit switcher for Home Manager => (re)start service when changing config
  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "24.11";
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
