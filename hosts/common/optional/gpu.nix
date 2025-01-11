{ config, lib, pkgs, modulesPath, ... }:
{

  #---------------------------------------------------------------------
  # Direct Rendering Infrastructure (DRI) support, both for 32-bit and 64-bit, and
  # Make sure opengl is enabled
  #---------------------------------------------------------------------
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;

    #---------------------------------------------------------------------
    # Install additional packages that improve graphics performance and compatibility.
    #---------------------------------------------------------------------
    extraPackages = with pkgs; [
      intel-media-driver      # LIBVA_DRIVER_NAME=iHD
      vaapiIntel                  # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
      vulkan-validation-layers
   ];
  };

  # Load intel/nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  hardware.nvidia = {

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Set bus IDs in the host configuration
      #intelBusId = "PCI:0:2:0";
      #nvidiaBusId = "PCI:1:0:0";
    };

    # Modesetting is required.
    modesetting.enable = true;

    #nvidiaPersistenced = true;

    # TODO: Debug why sleep suspend fails when these are enabled
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    #dynamicBoost.enable = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
