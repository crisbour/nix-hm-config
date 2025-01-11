{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.yubikey-touch-detector;
in
{
  options.services.yubikey-touch-detector = {
    enable = mkEnableOption "Yubikey touch detector through libnotify, written in Go";

    package = mkOption {
      type = types.package;
      default = pkgs.yubikey-touch-detector;
      description = ''
        The package to use for the Yubikey touch detector
      '';
    };
    socket.enable = mkOption {
      type = types.bool;
      default = true;
      description = "starting the process only when the socket is used";
    };
    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ "--libnotify" ];
      defaultText = literalExpression ''[ "--libnotify" ]'';
      description = ''
        Extra arguments to pass to the tool. The arguments are not escaped.
      '';
    };
    notificationSound = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Play sounds when the YubiKey is waiting for a touch.
      '';
    };
    notificationSoundFile = mkOption {
      type = types.str;
      default = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/window-attention.oga";
      description = ''
        Path to the sound file to play when the YubiKey is waiting for a touch.
      '';
    };
  };

  config = mkIf cfg.enable {

    # Necessary in path for accessing icon
    home.packages = [ cfg.package ];

    systemd.user.sockets.yubikey-touch-detector = mkIf cfg.socket.enable {
      Unit.Description = "Unix socket activation for YubiKey touch detector service";
      Socket = {
        ListenFIFO = "%t/yubikey-touch-detector.sock";
        RemoveOnStop = true;
        SocketMode = "0660";
      };
      Install.WantedBy = [ "sockets.target" ];
    };

   systemd.user.services.yubikey-touch-detector = {
       Unit = {
         Description = "YubiKey touch detector";
         Requires = [ "yubikey-touch-detector.socket" ];
       };

       Service = {
         Environment = [
           "PATH=${lib.makeBinPath [ pkgs.gnupg cfg.package ]}"
           # show desktop notifications using libnotify
           "YUBIKEY_TOUCH_DETECTOR_LIBNOTIFY=true"
           # enable debug logging
           "YUBIKEY_TOUCH_DETECTOR_VERBOSE=true"
         ];
         ExecStart = toString (pkgs.writeShellScript "yubikey-touch-detector" ''
           export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
           yubikey-touch-detector ${concatStringsSep " " cfg.extraArgs}
         '');
         Restart = "on-failure";
         RestartSec = 1;
       };

       Install = {
         WantedBy = [ "default.target" ];
         Also = [ "yubikey-touch-detector.socket" ];
       };
     };
    # Play sound when the YubiKey is waiting for a touch
    systemd.user.services.yubikey-touch-detector-sound =
      let
        file = cfg.notificationSoundFile;
        yubikey-play-sound = pkgs.writeShellScriptBin "yubikey-play-sound" ''
          socket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/yubikey-touch-detector.socket"

          while true; do

              if [ ! -e "$socket" ]; then
                  printf '{"text": "Waiting for YubiKey socket"}\n'
                  while [ ! -e "$socket" ]; do sleep 1; done
              fi
              printf '{"text": ""}\n'

              ${lib.getBin pkgs.netcat}/bin/nc -U "$socket" | while read -n5 cmd; do

                if [ "''${cmd:4:1}" = "1" ]; then
                  printf "Playing ${file}\n"
                  ${pkgs.mpv}/bin/mpv --volume=100 ${file} > /dev/null
                else
                  printf "Ignored yubikey command: $cmd\n"
                fi
              done

              ${lib.getBin pkgs.coreutils}/bin/sleep 1
          done
        '';
      in
      lib.mkIf cfg.notificationSound {
        Unit = {
          Description = "Play sound when the YubiKey is waiting for a touch";
          Requires = [ "yubikey-touch-detector.service" ];
        };
        Service = {
          ExecStart = "${lib.getBin yubikey-play-sound}/bin/yubikey-play-sound";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install.WantedBy = [ "yubikey-touch-detector.service" ];
      };
  };
}
