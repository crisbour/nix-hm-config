# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd = {
    supportedFilesystems = ["btrfs"];
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
    ];
  };

  # vhost_vsock: Enables the capacity to launch vm with a virtual socket (network)
  boot.kernelModules = [
    "intel_pstate"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # TODO Setup keyfile
  #boot.initrd.secrets = {
  #  "/crypto_keyfile.bin" = null;
  #};

  # ip forwarding is needed for NAT'ing to work.
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  boot.kernelParams = [
  ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "noatime"
        "compress=zstd"
        "ssd"
      ];
    };

    "/nix" = {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "noatime"
        "compress=zstd"
        "ssd"
      ];
    };

    "/home" = {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "noatime"
        "compress=zstd"
        "ssd"
      ];
    };

    "/data" = {
      device = "/dev/disk/by-uuid/f0017ddc-8ffe-4ac6-a830-afe7cba234a7";
      fsType = "btrfs";
      options = [
        "subvol=data"
        "noatime"
        "compress=zstd"
        "autodefrag"
      ];
    };

    #"/persist" = {
    #  device = "/dev/mapper/${hostname}";
    #  fsType = "btrfs";
    #  options = [
    #    "subvol=persist"
    #    "noatime"
    #    "compress=zstd"
    #  ];
    #  neededForBoot = true;
    #};

    #"/swap" = {
    #  device = "/dev/mapper/${hostname}";
    #  fsType = "btrfs";
    #  options = [
    #    "subvol=swap"
    #    "noatime"
    #  ];
    #};
  };

  swapDevices = [
    {
      device = "/dev/nvme0n1p1";
    }
  ];


  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

}