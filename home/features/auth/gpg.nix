{ config, lib, pkgs, ... }:
let
  agentTTL = 60 * 60 * 12; # 12 hours
  hasGUI = config.home.user-info.has_gui;
  inherit (config.home) user-info;
in {

  home.sessionVariables = {
    #SSH_AUTH_SOCK = lib.mkForce "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
  };

  home.packages = with pkgs; [
    gnupg
    pinentry-qt
  ];

  # TODO: Configure with public keyserver: https://github.com/hardselius/dotfiles/blob/110d2b106fdf2e9b30a8f0ae66d3e0ea97f52824/home/gpg.nix#L51
  # => No need to import keys from backup
  programs.gpg = {
    enable = user-info.gpg.enable;
    # For options details check: https://gnupg.org/documentation/manuals/gnupg/Option-Index.html
    settings = {
      # TODO: Replace with: default-key = user-info.gpg.masterKey;
      # in order to allow multiple hosts definitions
      default-key = user-info.gpg.masterKey;
      default-recipient = "0xAEF4A543011E8AC1";
      # No comments in signature
      no-comments = false;
      # No version in output
      no-emit-version = true;
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
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Always show the fingerprint
      with-fingerprint = true;
      # Enable smartcard
      use-agent = true;
    };
    scdaemonSettings = {
      disable-ccid = true;
      # FIXME: The PIN caching problem is cause by pcsc-shared, since gpg-agent will release the lock to let other applications access pcscd
      # Disable for now causes unusability with FIDO and auth application
      #pcsc-shared = true;
      #pcsc-driver = "libpcsclite.so.1";
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
    pinentry.package     = pkgs.pinentry-qt;
    verbose              = true;
    extraConfig = ''
      debug-pinentry
      debug ipc
    '';
  };

  home.file.".gnupg/sshcontrol" = {
    text = ''
      2C5FF24D5F6271C6E8DB256D9E20691015288800
    '';
  };

}
