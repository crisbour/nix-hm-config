{ pkgs, lib, ... }:
let
  hasGUI = true;
in
{
  systemd.user.sockets.yubikey-touch-detector = {
    Unit.Description = "Unix socket activation for YubiKey touch detector service";
    Socket = {
      ListenFIFO = "%t/yubikey-touch-detector.sock";
      RemoveOnStop = true;
      SocketMode = "0660";
    };
    Install.WantedBy = [ "sockets.target" ];
  };

 systemd.user.services.yubikey-touch-detector =
   lib.mkIf hasGUI {
     Unit = {
       Description = "YubiKey touch detector";
       Requires = [ "yubikey-touch-detector.socket" ];
     };

     Service = {
       Environment = [
         "PATH=${lib.makeBinPath [ pkgs.gnupg pkgs.yubikey-touch-detector ]}"
         # show desktop notifications using libnotify
         "YUBIKEY_TOUCH_DETECTOR_LIBNOTIFY=true"
         # enable debug logging
         "YUBIKEY_TOUCH_DETECTOR_VERBOSE=false"
       ];
       ExecStart = toString (pkgs.writeShellScript "yubikey-touch-detector" ''
         export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
         yubikey-touch-detector --libnotify
       '');
       Restart = "always";
       RestartSec = 5;
     };

     Install = {
       WantedBy = [ "default.target" ];
       Also = [ "yubikey-touch-detector.socket" ];
     };
   };
}
