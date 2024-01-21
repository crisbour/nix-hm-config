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
    ../programs
  ] ++ (builtins.attrValue outputs.homeManagerModules);

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
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  # A systemd unit switcher for Home Manager => (re)start service when changing config
  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "23.11";
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
    #sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      FLAKE = "$HOME/Documents/Scripts/Linux/nix-hm-config";
      COLORTERM = "truecolor";
      VISUAL    = "${editor}";
      EDITOR    = "${editor}";
      SHELL     = "${shell}";
      TERMINAL  = "${terminal}";
      #SSH_AUTH_SOCK = lib.mkForce "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  # Allow Nix to handle fonts
  fonts.fontconfig.enable = true;

  # Alternative to plain direnv, add watch method to evaluate state of shell
  services.lorri.enable = true;

  services.udiskie.enable = true;

  # TODO: Still more to improve: https://github.com/Misterio77/nix-config/blob/main/home/misterio/global/default.nix

}
