{ config, lib, pkgs, ... }:
{
  # Configure container runtime via mySystem.virtualisation module instead:
  mySystem.virtualisation = {
    enable = true;
    oci = "podman";  # or "docker"
    nvidia.enable = config.mySystem.info.has_nvidia;
  };

  environment.systemPackages = [ pkgs.distrobox ];
}
