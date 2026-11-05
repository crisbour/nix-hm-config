{ config, lib, pkgs, ... }:
{
  mySystem.docker = {
    enable = true;
    nvidia.enable = config.mySystem.info.has_nvidia;
  };

  # WARN: gitlab-runner defines this as "mkDefault true",
  # hence making sure we avoid using docker
  virtualisation.docker = {
    enable = true;
    # Use the rootless mode - run Docker daemon as non-root user
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  #virtualisation.podman = {
  #  enable = true;
  #  # Create a `docker` alias for podman, to use it as a drop-in replacement
  #  #dockerCompat = true;
  #  #dockerSocket.enable = true;
  #};

  environment.systemPackages = [ pkgs.distrobox];
}
