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
    xwaylandvideobridge
    weston
  ];

  # FIXME: Not quite working as I wished, tweak brightness levels
  services.wluma = {
    enable = false;
    # FIXME: wluma still in dev, ddcutil doesn't work
    #package = pkgs.unstable.wluma;
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

      #[[output.ddcutil]]
      #name = "LG HDR 4K"
      #capturer = "none"
    '';
  };
}
