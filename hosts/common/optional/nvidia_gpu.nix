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

  # Load intel/nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
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
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
