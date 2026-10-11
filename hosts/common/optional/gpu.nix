{ config, lib, pkgs, modulesPath, ... }:
{

  #---------------------------------------------------------------------
  # Direct Rendering Infrastructure (DRI) support, both for 32-bit and 64-bit, and
  # Make sure opengl is enabled
  #---------------------------------------------------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    #---------------------------------------------------------------------
    # Install additional packages that improve graphics performance and compatibility.
    #---------------------------------------------------------------------
    extraPackages = with pkgs; [
      intel-media-driver      # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver      # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libva-vdpau-driver
      libvdpau-va-gl
      vulkan-validation-layers
   ];
  };
}
