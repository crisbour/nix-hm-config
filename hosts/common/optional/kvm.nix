{ config, lib, pkgs, modulesPath, ... }:
{
  boot.initrd = {
    kernelModules = [
      # Useful for VM to interact with hardware
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      #"vfio_virqfd"
      "virtio_pci"
      "virtio_blk"

      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };

  boot.kernelParams = [
    # enable IOMMU
    "intel_iommu=on"
    "vfio-pci.ids=10de:25b9" # nvidia address
  ];

  hardware.opengl.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
          packages = with pkgs; [ OVMFFull.fd ];
        };
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virtiofsd
    libvirt
    virt-manager
  ];
}


