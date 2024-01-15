{ config, lib, pkgs, specialArgs, ... }:

let
  # hacky way of determining which machine I'm running this from
  inherit (specialArgs) withGUI isDesktop;
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [
    ./modules
    ./programs
  ];

  home = {
    stateVersion = "23.11";
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
  };

  # Allow Nix to handle fonts
  fonts.fontconfig.enable = true;

  # You can add services as follows:
  #services.<program> = {
  #  enable = true;
  #  ...
  #}

  # Alternative to plain direnv, add watch method to evaluate state of shell
  services.lorri.enable = isLinux;

  services.udiskie.enable = isLinux;

}
