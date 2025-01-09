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
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default

    ./waybar
    ./waypaper.nix
    ./swayosd.nix
    ./swaylock.nix
    ./hypridle.nix
    ./swaync
    ./scripts
  ];

  services.wluma = {
    enable = true;
    config = ''
      [als.iio]
      path = "/sys/bus/iio/devices"
      thresholds = { 0 = "night", 20 = "dark", 80 = "dim", 250 = "normal", 500 = "bright", 800 = "outdoors" }

      [[output.backlight]]
      name = "eDP-1"
      path = "/sys/class/backlight/intel_backlight"
      capturer = "wayland"

      [[keyboard]]
      name = "keyboard-dell"
      path = "/sys/bus/platform/devices/dell-laptop/leds/dell::kbd_backlight"
    '';
  };
}
