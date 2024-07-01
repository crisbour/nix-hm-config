# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        #<nixos-hardware/dell/xps/15-9550>
        # FIXME: Nvidia configs fail on suspend
        ./gpu.nix
        <home-manager/nixos>
        ./yubikey.nix
        ./fonts.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # ip forwarding is needed for NAT'ing to work.
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    #extraGSettingsOverrides = {
    #  "org.gnome.mutter".experimental-features = "['scale-monitor-framebuffer']";
    #};
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
  services.automatic-timezoned.enable = true;
  programs.dconf = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # gnome pinentry workaround?
  services.dbus.packages = [
    pkgs.gcr
    #gnome2.GConf
  ];

  # Enable sound with pipewire.
  sound.enable = true;
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
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cristi = {
    isNormalUser = true;
    description = "Cristi Bourceanu";
    extraGroups = [ "networkmanager" "wheel" "lxd" "libvirtd"];
    packages = with pkgs; [
      nixos-option
      brave
      firefox
      gcc
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "cristi";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  systemd.services.lxd.path = with pkgs; [
    qemu_kvm
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Found out more about how to configure virt-manager at: https://nixos.wiki/wiki/Virt-manager
    coreutils
    gnome.gnome-tweaks
    gnome.gnome-sound-recorder
    gnomeExtensions.unite
    pciutils
    qemu
    qemu_kvm
    tcpdump
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    virt-manager
  #  wget
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "4 weeks";
    options = "-d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #  #disableCcid = true;
  #  #pinentryFlavor = "gnome3";
  #};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # ==================================================================================
  # User defined
  # ==================================================================================
  # Adding lxd and overriding the package
  virtualisation = {
    lxd = {
      enable=true;

      # using the package of our overlay
      # package = pkgs.lxd-vmx.lxd.override {useQemu = true;};
      recommendedSysctlSettings=true;
    };

    lxc = {
      enable = true;
      lxcfs.enable = true;
      # TODO Add systemConfig to store lxcpath and btrfs.root paths
      systemConfig =
        ''
          lxc.lxcpath = /var/lib/lxd/storage-pools # The location in which all containers are stored.
        '';
    };

    libvirtd = {
      enable = true;
      qemu.runAsRoot = true;
    };
  };

}
