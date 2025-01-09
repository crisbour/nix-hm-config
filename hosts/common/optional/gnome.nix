{ inputs, outputs, pkgs, ... }:

{
  imports = [
    ./desktop.nix
  ];

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


  # gnome pinentry workaround?
  services.dbus.packages = [
    pkgs.gcr
  ];

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.battery-health-charging
    gnome.gnome-tweaks
    gnome.gnome-sound-recorder
    gnomeExtensions.unite
  ];

}
