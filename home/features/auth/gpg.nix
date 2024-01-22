{ config, lib, pkgs, ... }:
let
  agentTTL = 60 * 60 * 12; # 12 hours
  inherit (pkgs.stdenv) isLinux;
  #hasGUI = config.wayland.enable || config.xorg.enable;
  hasGUI = true;
  inherit (config.home) user-info;
in {

  home.sessionVariables = {
    #SSH_AUTH_SOCK = lib.mkForce "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
  };

  home.packages = with pkgs; [
    gnupg
    pinentry-gnome
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
      # Disable recipient key ID in messages
      throw-keyids = true;
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
    pinentryFlavor       = "gnome3";
    verbose              = true;
    # pinentry-program /usr/bin/pinentry-gnome3
    extraConfig = ''
      debug-pinentry
      debug ipc
    '';
  };
}
