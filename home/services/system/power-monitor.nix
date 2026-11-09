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
      if [[ $prev != $profile ]]; then

        echo setting power profile to $profile
        notify-send "Changing power profile to $profile"

        powerprofilesctl set $profile

        # blur and animations only active on AC power
        if [[ $profile == "power-saver" ]]; then
          lua_config='hl.config({
            decoration = { blur = { enabled = false } },
            animations = { enabled = false },
          })'
        else
          lua_config='hl.config({
            decoration = { blur = { enabled = true } },
            animations = { enabled = true },
          })'
        fi
        for i in $(hyprctl instances -j | jaq ".[].instance" -r); do
          hyprctl -i "$i" eval "$lua_config"
        done

      fi

      prev=$(powerprofilesctl get)

      # wait for the next power change event, err kernel changes value directly as a pointer in mem perhaps
      inotifywait -qq "$BAT_STATUS" "$BAT_CAP" -t 60
      #sleep 5
    done
  '';

  dependencies = with pkgs; [
    coreutils
    config.wayland.windowManager.hyprland.package
    power-profiles-daemon
    inotify-tools
    libnotify
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
