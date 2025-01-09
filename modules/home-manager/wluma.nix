{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.services.wluma;
  wluma-backlight = pkgs.writeTextFile {
    name = "90-wluma-backlight.rules";
    text = builtins.replaceStrings [ "/bin/chgrp" "/bin/chmod" ] [
      "${pkgs.coreutils}/bin/chgrp"
      "${pkgs.coreutils}/bin/chmod"
    ] (builtins.readFile "${inputs.wluma}/90-wluma-backlight.rules");
    destination = "/etc/udev/rules.d/90-wluma-backlight.rules";
  };
  tomlFormat = pkgs.formats.toml { };
in {
  options.services.wluma = {
    enable = lib.mkEnableOption {
      default = false;
      description = lib.mdDoc "Whether to activate wluma, a service to regulate display brightness";
      example = lib.literalExpression "true";
    };
    package = lib.mkPackageOption pkgs "wluma" {};
    systemdEnable = lib.mkEnableOption {
      default = false;
      description = lib.mdDoc "Whether to enable the wluma systemd service";
      example = lib.literalExpression "true";
    };
    hyprlandEnable = lib.mkEnableOption {
      default = false;
      description = lib.mdDoc "Whether to run wluma through hyprland";
      example = lib.literalExpression "true";
    };
    config = lib.mkOption {
      type = lib.types.str;
      default = { };
      example = lib.literalExpression ''
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

  };

  config = lib.mkIf cfg.enable {
    #services.udev.packages = [ wluma-backlight ];

    home.packages = [
      cfg.package # Automatic brightness adjustment based on screen contents and ALS
    ];

    xdg.configFile."wluma/config.toml".source = pkgs.writeText "wluma-config.toml" cfg.config;

    #wayland.windowManager.hyprland.settings.exec-once = lib.mkIf cfg.hyprlandEnable [ "wluma" ];

    # TODO: How to make service
    systemd.user.services.wluma =
       {
        Unit = {
          Description =
            "Adjusting screen brightness based on screen contents and amount of ambient light";
          Documentation = "https://github.com/maximbaz/wluma";
        };
        Service = {
          ExecStart = "${pkgs.wluma}/bin/wluma";
          PrivateNetwork = true;
          PrivateMounts = false;
          Restart = "always";
          RestartSec = 1;
          #EnvironmentFile = "-%E/wluma/service.conf";
        };
      };
  };
}
