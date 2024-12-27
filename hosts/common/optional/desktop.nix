{ inputs, outputs, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = false;
  };
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      ["org.gnome.mutter"]
      experimental-features=['scale-monitor-framebuffer', 'x11-randr-fractional-scaling'];
    '';
  };

  # GNOME specific: https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  # TODO: How to enable useGlobalPkgs for home-manager
  environment.gnome.excludePackages = (with pkgs; [
            #gnome-photos
            gnome-tour
          ]) ++ (with pkgs.gnome; [
            #cheese # webcam tool
            gnome-music
            #gedit # text editor
            epiphany # web browser
            geary # email reader
            #gnome-characters
            tali # poker game
            iagno # go game
            hitori # sudoku game
            atomix # puzzle game
            #yelp # Help view
            gnome-contacts
            #gnome-initial-setup
          ]);

  programs.dconf = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable firmware update service
  services.fwupd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # gnome pinentry workaround?
  services.dbus.packages = [
    pkgs.gcr
    #gnome2.GConf
  ];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "cristi";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.gnome-sound-recorder
    gnomeExtensions.unite
    xorg.xhost # Necessary for allowing docker X11 access
  #  wget
  ];

}
