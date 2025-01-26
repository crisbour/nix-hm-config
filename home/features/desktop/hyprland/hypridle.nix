{
  pkgs,
  lib,
  ...
}: let
  # NOTE: Avoid multplie {hypr,sway}lock instances: https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/
  my_lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
  #my_lock_cmd = "pidof swaylock || ${pkgs.swaylock}/bin/swaylock";

  suspendScript = pkgs.writeShellScript "suspend-script" ''
    BAT=$(echo /sys/class/power_supply/BAT*)
    BAT_STATUS="$BAT/status"

    # Only suspend if audio isn't running and on battery
    running=${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running
    battery_status=$(cat "$BAT_STATUS")
    if [[ -n running && "$battery_status" == "Discharging" ]]; then
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
        lock_cmd = my_lock_cmd;
        #before_sleep_cmd = "loginctl lock-session";
        before_sleep_cmd = "${my_lock_cmd}";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 120; # 2 min
          # save the current brightness and dim the screen over a period of
          # 1 second
          on-timeout = "${brillo} -O; ${brillo} -u 1000000 -S 5";
          # brighten the screen over a period of 500ms to the saved value
          on-resume = "${brillo} -I -u 500000";
        }
        {
          timeout = 300; # 5 min
          on-timeout = "${my_lock_cmd}; hyprctl dispatch dpms off";        # screen off when timeout has passed
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
