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
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default

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
