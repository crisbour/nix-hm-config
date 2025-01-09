{ inputs, outputs, pkgs, ... }:

{
  # X11 windowing system.
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    # FIXME: maximum keycode 708 not supported
    #xkb = {
    #  layout = "us";
    #  variant = "";
    #};
  };

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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "cristi";
}
