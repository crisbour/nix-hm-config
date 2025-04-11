{ config, lib, pkgs, ... }:
let
  cfg = config.mySystem.docker;
in
{
  options.mySystem.docker = {
    enable = lib.mkEnableOption "Enable Docker";
    nvidia.enable = lib.mkEnableOption "Enable Nvidia Docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        #cdi = true;
        fixed-cidr-v6 = "fd00::/80";
        ipv6 = true;
      };
    };

    hardware.nvidia-container-toolkit.enable = cfg.nvidia.enable;
    services.xserver.videoDrivers = lib.mkIf cfg.nvidia.enable [ "nvidia" ];

    users.users.cristi.extraGroups = ["docker"];

    environment.systemPackages = with pkgs; [
      xorg.xhost # Necessary for allowing docker X11 access
    ];

    # kernel module for forwarding to container to work
    boot.kernelModules = [ "nf_nat_ftp" ];

    #FIXME: Allow X11 host through docker:
    #environment.shellInit = ''
    #  [ -n "$DISPLAY" ] && xhost +local:docker || true
    #'';
    #};
  };
}
