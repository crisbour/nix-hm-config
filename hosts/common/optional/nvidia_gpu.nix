{ config, lib, pkgs, modulesPath, ... }:
{

  hardware.graphics = {
    #---------------------------------------------------------------------
    # Install additional packages that improve graphics performance and compatibility.
    #---------------------------------------------------------------------
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
   ];
  };


  # Enable usage of nvidia through docker/podman
  hardware.nvidia-container-toolkit.enable = true;


  # Load intel/nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    # Required for Wayland compositors like Hyprland to handle buffers correctly
    "nvidia-drm.fbdev=1"
    # Helps with power management on some laptops, though experimental
    "nvidia.NVreg_DynamicPowerManagement=0x02"
    # Following is recommender by Hyprland but fails on suspend
    #"nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  hardware.nvidia = {

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };

    # Modesetting is required.
    modesetting.enable = true;

    #nvidiaPersistenced = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

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
