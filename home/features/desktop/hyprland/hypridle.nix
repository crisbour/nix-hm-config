{
  pkgs,
  lib,
  config,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    BAT=$(echo /sys/class/power_supply/BAT*)
    BAT_STATUS="$BAT/status"

    # Only suspend if audio isn't running and on battery
    running=${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running
    battery_status=$(cat "$BAT_STATUS")
    if [[ -n running && "$battery_status" == "Discharging" ]]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi

    # NOTE: It seems that locking before suspend interferes with suspend service
    # Lock screen
    swaylock
    #hyprlock
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
          timeout = 120; # 2 min
          # save the current brightness and dim the screen over a period of
          # 1 second
          on-timeout = "${brillo} -O; ${brillo} -u 1000000 -S 5";
          # brighten the screen over a period of 500ms to the saved value
          on-resume = "${brillo} -I -u 500000";
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
