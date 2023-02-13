{ config, lib, pkgs, specialArgs, ... }:

let
  # hacky way of determining which machine I'm running this from
  inherit (specialArgs) withGUI isDesktop;
  inherit (pkgs.stdenv) isLinux;

  packages = import ./packages.nix;
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
#    BROWSER = "${pkgs.firefox}/bin/firefox";
  };
  home.packages = packages pkgs withGUI;

  # Allow some or all Unfree packages
  #imports = [ ./config/base.nix ];
  nixpkgs.config.allowUnfree = true;

  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;

  # Allow Nix to handle fonts
  fonts = { fontconfig = { enable = true; }; };

  programs = import ./programs.nix {
    inherit pkgs;
    inherit config;
    inherit lib;
  } withGUI;


  # You can add services as follows:
  #services.<program> = {
  #  enable = true;
  #  ...
  #}

  # Alternative to plain direnv, add watch method to evaluate state of shell
  services.lorri.enable = isLinux;

  services.gpg-agent.enable = isLinux;
  services.gpg-agent.enableExtraSocket = withGUI;
  services.gpg-agent.enableSshSupport = isLinux;


  xdg.enable = true;

}
