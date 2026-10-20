{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}:
{
  # Inspired from: https://github.com/Frost-Phoenix/nixos-config/tree/c151860c8e576755dc60530e2527005dbcc79750
  imports = [
    ../common

    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix

    ./waybar
    #./waypaper.nix
    ./swayosd.nix
    ./swaylock.nix
    ./hypridle.nix
    ./swaync
    ./scripts
    ./polkitagent.nix
    ./hyprspace.nix
  ];

  home.packages = with pkgs; [
    weston
    qt5.qtwayland
    qt6.qtwayland
  ];

}
