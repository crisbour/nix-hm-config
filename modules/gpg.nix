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

 #systemd.user.services.yubikey-touch-detector =
 #  lib.mkIf hasGUI {
 #    Unit = {
 #      Description = "YubiKey touch detector";
 #      PartOf = [ "graphical-session.target" ];
 #    };

 #    Service = {
 #      ExecStart =
 #        "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector --libnotify";
 #      Environment = [ "PATH=${lib.makeBinPath [ pkgs.gnupg ]}" ];
 #      Restart = "always";
 #      RestartSec = 5;
 #    };

 #    Install.WantedBy = [ "graphical-session.target" ];
 #  };
}
