{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      #cdi = true;
      fixed-cidr-v6 = "fd00::/80";
      ipv6 = true;
    };
  };
  # FIXME Only enable if NVIDIA is present. Add a config value in modules
  # HACK: Conditional assert on nvidia driver installed
  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  users.users.cristi.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    docker
  ];

  # kernel module for forwarding to container to work
  boot.kernelModules = [ "nf_nat_ftp" ];

   # Export X11 host to docker
  environment.shellInit = ''
    [ -n "$DISPLAY" ] && xhost +si:localuser:$USER || true
  '';
}
