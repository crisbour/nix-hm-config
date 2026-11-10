{ config, lib, pkgs, ... }:
{

  programs.ssh.startAgent = false;

  # Investigate if this is more reliable than gpg-agent: https://github.com/FiloSottile/yubikey-agent
  #services.yubikey-agent.enable = true;

  # Enable PC/SC daemon for smartcard support
  services.pcscd = {
    enable = true;
    plugins = with pkgs; [ libykneomgr ccid ];
  };

  # YubiKey utilities
  environment.systemPackages = with pkgs; [
    yubikey-manager            # ykman - modern YubiKey management
    yubico-pam                 # PAM module for YubiKey auth
    yubikey-touch-detector     # Notify when YubiKey touch is needed
    # GUI tools
    yubioath-flutter           # YubiKey OTP/TOTP manager
  ];

  # UDEV rules for YubiKey access
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  # Enable GPG smartcard support
  hardware.gpgSmartcards.enable = true;

  # Enable Polkit (for GUI authentication)
  security.polkit.enable = true;

  # =============================================================================
  # PAM Configuration for YubiKey
  # =============================================================================
  security.pam = {
    # Enable YubiKey challenge-response for sudo
    services = {
      # NOTE: Add yubikey to user auth manually:
      # ```
      # nix-shell -p pam_u2f
      # pamu2fcfg > ~/.config/Yubico/u2f_keys`
      # ```
      sudo = {
        u2fAuth = true;
        # Also enable yubico module
        yubicoAuth = true;
      };
      login.u2fAuth = false;  # Keep password for login (optional)
    };

    # YubiKey PAM module configuration
    yubico = {
      enable = true;
      # debug = true;  # Enable for troubleshooting
      mode = "challenge-response";
    };
  };

}

# Taken from: https://github.com/jonaswouters/nixos-configuration/blob/master/yubikey.nix
