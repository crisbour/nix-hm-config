{
  pkgs,
  lib,
  ...
}: let
  #my_lock_cmd = "noctalia msg session lock";
  my_lock_cmd = "pidof swaylock || swaylock";

  suspendScript = pkgs.writeShellScript "suspend-script" ''
    BAT=$(echo /sys/class/power_supply/BAT*)
    BAT_STATUS="$BAT/status"

    # Only suspend if audio isn't running and on battery
    # FIXME: Noctalia makes sound always running, for notification watching
    #running=${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running
    battery_status=$(cat "$BAT_STATUS")
    if [[ "$battery_status" == "Discharging" ]]; then
      ${pkgs.systemd}/bin/systemctl suspend
    else
      # TODO: If heavy computation is detected, reset hypridle timeout
      # Send to power monitor to switch to "balanced": `powerprofilesctl set "power-saver"`
      notify-send "Request power-monitor to switch to balanced"
    fi
  '';

  brillo = lib.getExe pkgs.brillo;
in {
  # screen idle
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        # Message noctalia to lock instead of causing a ping-pong dbus lock request between Noctlia and hypridle
        # Otherwise this causes infinite lock loop with Noctalia
        # Fix found: https://github.com/ryan4yin/nix-config/blob/96fc0e3502d896437af8df90a63b3ceb44fe9196/home/linux/gui/base/hypridle/default.nix#L64
        lock_cmd = my_lock_cmd;
        before_sleep_cmd = my_lock_cmd;
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
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({action = \"off\"})'";        # screen off when timeout has passed
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({action = \"on\"})'";          # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 600; # 10 min suspend
          on-timeout = suspendScript.outPath;
          #condition_cmd = "test if busy computation";
          #condition_retry = 300;
          #on-resome = powerProfileResume.outPath;
        }
      ];
    };
  };

  # TODO: Figure out a solution for heavy computation deference of power profile switch when on AC
  # checkout: https://github.com/thrawny/dotfiles/blob/c743dd1996508200615a1684fd2eab526f972e32/nix/home/nixos/hypridle.nix#L29
}
