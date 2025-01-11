{
  pkgs,
  lib,
  config,
  ...
}:
let
  script = pkgs.writeShellScript "power_monitor.sh" ''
    BAT=$(echo /sys/class/power_supply/BAT*)
    BAT_STATUS="$BAT/status"
    BAT_CAP="$BAT/capacity"

    AC_PROFILE="performance"
    BAT_PROFILE="power-saver"

    # wait a while if needed
    [[ -z $STARTUP_WAIT ]] || sleep "$STARTUP_WAIT"

    # start the monitor loop
    prev=0

    while true; do
      # read the current state
      if [[ $(cat "$BAT_STATUS") == "Discharging" ]]; then
        profile=$BAT_PROFILE
      else
        profile=$AC_PROFILE
      fi

      # set the new profile
      if [[ $prev != "$profile" ]]; then
        echo setting power profile to $profile
        powerprofilesctl set $profile
        if [[ $profile == "power-saver" ]]; then
          for i in $(hyprctl instances -j | jaq ".[].instance" -r); do
            hyprctl -i "$i" --batch 'keyword decoration:blur:enabled false; keyword animations:enabled false' 1>/dev/null
          done
        else
          for i in $(hyprctl instances -j | jaq ".[].instance" -r); do
            hyprctl -i "$i" --batch 'keyword decoration:blur:enabled true; keyword animations:enabled true' 1>/dev/null
          done
        fi
      fi

      prev=$profile

      # wait for the next power change event, err kernel changes value directly as a pointer in mem perhaps
      #inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
      sleep 5
    done
  '';

  dependencies = with pkgs; [
    coreutils
    config.wayland.windowManager.hyprland.package
    power-profiles-daemon
    #inotify-tools
    jaq
  ];
in
{
  # Power state monitor. Switches Power profiles based on charging state.
  # Plugged in - performance
  # Unplugged - power-saver
  systemd.user.services.power-monitor = {
    Unit = {
      Description = "Power Monitor";
      After = [ "power-profiles-daemon.service" ];
    };

    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      Type = "simple";
      ExecStart = script;
      Restart = "on-failure";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
