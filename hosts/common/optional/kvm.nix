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

    ];
  };

  boot.kernelParams = [
    # enable IOMMU
    "intel_iommu=on"
    # FIXME: Only enable if nvidia enabled
    #"vfio-pci.ids=10de:25b9" # nvidia address
  ];

  # Bind specified devices to vfio-pci
  #boot.extraModprobeConfig = ''
  #  options vfio-pci ids=10de:25b9
  #  softdep nvidia pre: vfio-pci
  #'';

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        #runAsRoot = true;
        swtpm.enable = true;
        # File sharing
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
      allowedBridges = [
        "virbr0"
      ];
    };
    spiceUSBRedirection.enable = true;
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Enable spice-vdagentd for clipboard sharing
  services.spice-vdagentd.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virtiofsd
    virt-manager
    virt-viewer
    quickemu
    virtio-win
    virglrenderer
  ];
}


