{ config, lib, pkgs, ... }:
let
  cfg = config.mySystem.virtualisation;
in
{
  options.mySystem.virtualisation = {
    oci = lib.mkOption {
      type = lib.types.enum [ "docker" "podman" ];
      default = "docker";
      description = "OCI container runtime to use (docker or podman)";
    };
    enable = lib.mkEnableOption "Enable container runtime";
    nvidia.enable = lib.mkEnableOption "Enable Nvidia Docker";
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && cfg.oci == "docker") {
      virtualisation.docker = {
        enable = true;
        daemon.settings = {
          fixed-cidr-v6 = "fd00::/80";
          ipv6 = true;
        };
      };
      users.users.cristi.extraGroups = [ "docker" ];
    })

    (lib.mkIf (cfg.enable && cfg.oci == "podman") {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
      };
    })

    (lib.mkIf cfg.enable {
      hardware.nvidia-container-toolkit.enable = cfg.nvidia.enable;
      services.xserver.videoDrivers = lib.mkIf cfg.nvidia.enable [ "nvidia" ];
      environment.systemPackages = with pkgs; [ xhost ];
      boot.kernelModules = [ "nf_nat_ftp" ];
    })
  ];
}
