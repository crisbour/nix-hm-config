{ config, lib, pkgs, modulesPath, ... }:
{
  boot.initrd = {
    kernelModules = [
      # Useful for VM to interact with hardware
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      #"vfio_virqfd" # Recent version of the kernel has this integrated
      "virtio"
      "virtio_pci"
      "tun"

    ] ++ lib.optionals config.mySystem.info.has_nvidia [
      "nvidia"
      #"nvidia_modeset"
      #"nvidia_uvm"
      #"nvidia_drm"
    ];
  };

  boot.kernelParams = [
    # enable IOMMU
    "intel_iommu=on"
    # FIXME: Only enable if nvidia enabled
    #"vfio-pci.ids=10de:25b9" # nvidia address
  ];

  boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" ];

  # Bind specified devices to vfio-pci
  #boot.extraModprobeConfig = ''
  #  options vfio-pci ids=10de:25b9
  #  softdep nvidia pre: vfio-pci
  #'';

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
      allowedBridges = [
        "virbr0"
      ];
    };
    spiceUSBRedirection.enable = true;
  };

  # Enable spice-vdagentd for clipboard sharing
  services.spice-vdagentd.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virtiofsd
    virt-manager
    quickemu
    virtio-win
    virglrenderer
  ];
}


