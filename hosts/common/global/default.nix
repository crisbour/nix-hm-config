# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, pkgs, ... }:

{
  imports =
    [
        inputs.home-manager.nixosModules.home-manager
        #<home-manager/nixos>
        ./locale.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable firmware update service
  services.fwupd.enable = true;

  systemd.services.lxd.path = with pkgs; [
    qemu_kvm
  ];

  # TODO: Make prebuild binaries work in NixOS
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      stdenv.cc.cc.lib
      zlib
      fuse3
      openssl
      curl
      SDL2
      xorg.libX11
      xorg.libXext
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXinerama
      libGL
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # NFS for UoE
    samba
    cifs-utils
    # Found out more about how to configure virt-manager at: https://nixos.wiki/wiki/Virt-manager
    coreutils
    pciutils
    qemu
    qemu_kvm
    tcpdump
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    virt-manager
  #  wget
  ];

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "4 weeks";
    options = "-d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
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

      # This enables lxcfs, which is a FUSE fs that sets up some things so that
      # things like /proc and cgroups work better in lxd containers.
      # See https://linuxcontainers.org/lxcfs/introduction/ for more info.
      #
      # Also note that the lxcfs NixOS option says that in order to make use of
      # lxcfs in the container, you need to include the following NixOS setting
      # in the NixOS container guest configuration:
      #
      defaultConfig = "lxc.include = ''${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf";

      systemConfig = ''
        lxc.lxcpath = /var/lib/lxd/storage-pools # The location in which all containers are stored.
      '';
    };

    libvirtd = {
      enable = true;
      qemu.runAsRoot = true;
    };
  };

  # kernel module for forwarding to work
  boot.kernelModules = [ "nf_nat_ftp" ];

  # Set up networking bridge for LXD
  networking = {
    bridges = {
      lxdbr0 = {
        interfaces = [];
      };
    };
    nat = {
      enable = true;
      internalInterfaces = ["lxdbr0"];
      externalInterface = "eth0"; # Replace with your actual external interface
    };
  };
  networking.firewall.trustedInterfaces = [ "lxdbr0" ];

}
