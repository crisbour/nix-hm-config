{ config, lib, pkgs, specialArgs, ... }:

let
  # hacky way of determining which machine I'm running this from
  inherit (specialArgs) withGUI isDesktop;
  inherit (pkgs.stdenv) isLinux;

  packages = import ./packages.nix;
in
{
  imports = [
    ./modules
    ./programs
  ];

  home = {
    stateVersion = "23.11";
    inherit username;
    inherit homeDirectory;
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
