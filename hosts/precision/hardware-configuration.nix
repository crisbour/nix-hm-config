# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
let
  snd = "/sys/class/sound/hwC0D0";
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../common/optional/encrypted-root.nix
      ../common/optional/ephemeral-btrfs.nix
      ../common/optional/hibernate-resume.nix
    ];

  boot.initrd = {
    availableKernelModules = [
      #"iwlwifi"
      "thunderbolt"
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "i915" ];
  };

  # vhost_vsock: Enables the capacity to launch vm with a virtual socket (network)
  boot.kernelModules = [
    "kvm"
    "kvm-intel"
    "intel_pstate"
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
    #"nvidia_uvm" # Required by CUDA: Unified Memory
    "vhost_vsock"
  ];
  #boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

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
    # NOTE Precision 5570 only supports s2idle
    "mem_sleep_default=s2idle"
    # FIXME Is this preventing suspend?
    #"ahci.mobile_lpm_policy=2" # Extreme SSD power saving: med_power_with_dipm=2 or min_power=3
    #"ibt=off"
    #"intel_iommu=igfx_off"
    "nvidia_drm.modeset=1"
    #"i915.enable_psr=0" # Panel Self Refresh (PSR) is a power saving feature that might cause flickering
  ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 32768;
    }
  ];


  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  # ==================================================================================
  # Quality of Life changes
  # ==================================================================================

  # Sound quality enable bottom speakers
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
    options snd-hda-intel model=alc289
    options snd-hda-intel enable=1,1
    options snd-hda-intel patch=hda-jack-retask.fw
  '';
  # Reference: https://discourse.nixos.org/t/fixing-audio-on-asus-strix-scar-17-g733qs/12687/9
  hardware.firmware = [ ( pkgs.writeTextDir "/lib/firmware/hda-jack-retask.fw" ( builtins.readFile ./hda-jack-retask.fw ) ) ];
  # Inspired from: https://github.com/snpschaaf/nixos-hardware/blob/12620020f76b1b5d2b0e6fbbda831ed4f5fe56e1/system76/darp6/default.nix#L80
  #hardware.firmware = [
  #      (pkgs.writeTextFile {
  #        name = "precision-audio-patch";
  #        destination = "/lib/firmware/precision-audio-patch";
  #        text = ''
  #          [codec]
  #          0x10ec0289 0x10280b1a 0

  #          [pincfg]
  #          0x17 0x90170151
  #          0x1e 0x90170150
  #        '';
  #      })
  #    ];
  # options snd-hda-intel patch=hda-jack-retask.fw

  # Perhaps similar issue as described here: https://github.com/NixOS/nixos-hardware/blob/master/dell/xps/15-9510/default.nix#L11
  # and here: https://github.com/NixOS/nixos-hardware/blob/master/dell/xps/15-9520/default.nix#L12
  #boot.extraModprobeConfig = ''
  #  options iwlwifi 11n_disable=8
  #  options iwlwifi power_save=1 disable_11ax=1
  #'';

  # Enable with over heating becomes and issue
  #services.thermald.enable = lib.mkDefault true;

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";

  powerManagement.powertop.enable = true;

  #services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
       governor = "powersave";
       turbo = "never";
    };
    charger = {
       governor = "performance";
       turbo = "auto";
    };
  };


}
