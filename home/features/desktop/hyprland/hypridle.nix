{
  pkgs,
  lib,
  config,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    BAT=$(echo /sys/class/power_supply/BAT*)
    BAT_STATUS="$BAT/status"

    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running and on battery
    if [ $? == 1 && $(cat "$BAT_STATUS") != "Discharging"]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  brillo = lib.getExe pkgs.brillo;
in {
  # screen idle
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        # FIXME: Avoid multplie hyprlock instances: https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/
        lock_cmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      };

      listener = [
        {
          timeout = 180; # 3 min
          # save the current brightness and dim the screen over a period of
          # 1 second
          on-timeout = "${brillo} -O; ${brillo} -u 1000000 -S 5";
          # brighten the screen over a period of 500ms to the saved value
          on-resume = "${brillo} -I -u 500000";
        }
        {
          timeout = 180; # 3 min
          # save the current brightness and dim the screen over a period of
          # 1 second
          on-timeout = "${brillo} -k -O; ${brillo} -k -u 1000000 -S 0";
          # brighten the screen over a period of 500ms to the saved value
          on-resume = "${brillo} -k -I -u 500000";
        }
        {
          timeout = 300; # 5 min
          on-timeout = "hyprctl dispatch dpms off";        # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on";          # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 600; # 10 min suspend
          on-timeout = suspendScript.outPath;
        }
      ];
    };
  };
}
