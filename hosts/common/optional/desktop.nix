{ inputs, outputs, pkgs, ... }:

{

  # TODO:: Better way to switch between DMs: https://github.com/redxtech/nixfiles/blob/42c7b209ed570ef2f1a24b06192bd09728a0c3a2/modules/nixos/desktop/wm.nix#L24

  programs.dconf = {
    enable = true;
  };

  # Display brightness contol
  programs.light.enable = true;

  # Enable firmware update service
  services.fwupd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "cristi";
}
