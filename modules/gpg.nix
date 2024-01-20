{ config, lib, pkgs, ... }:
let
  agentTTL = 60 * 60 * 12; # 12 hours
  inherit (pkgs.stdenv) isLinux;
  #hasGUI = config.wayland.enable || config.xorg.enable;
  hasGUI = true;
in {

  home.sessionVariables = {
    #SSH_AUTH_SOCK = lib.mkForce "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
  };

  home.packages = with pkgs; [
    gnupg
    #pinentry
  ];

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "0x152B728E9A90E3ED";
      no-comments = false;
      # Get rid of the copyright notice
      no-greeting = true;
      # Because some mailers change lines starting with "From " to ">From "
      # it is good to handle such lines in a special way when creating
      # cleartext signatures; all other PGP versions do it this way too.
      no-escape-from-lines = true;
      # Use a modern charset
      charset = "utf-8";
      ### Show keys settings
      # Always show long keyid
      keyid-format = "0xlong";
      # Always show the fingerprint
      with-fingerprint = true;
    };
    scdaemonSettings = {
      disable-ccid = true;
      pcsc-shared = true;
      pcsc-driver = "/usr/lib64/libpcsclite.so.1";
      #reader-port="Yubico Yubikey";
    };
  };

  services.gpg-agent = {
    enable               = true;
    defaultCacheTtl      = agentTTL;
    maxCacheTtl          = agentTTL;
    defaultCacheTtlSsh   = agentTTL;
    maxCacheTtlSsh       = agentTTL;
    #enableExtraSocket   = true;
    enableSshSupport     = true;
    enableZshIntegration = true;
    pinentryFlavor       = "gnome3";
    verbose              = true;
    extraConfig = ''
      debug-pinentry
      debug ipc
    '';
  };

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
