{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xorgserver
    xorg.xrandr
    xorg.xinit
    xorg.xauth
    xorg.xhost
    xterm
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.xrdp.openFirewall = true;
}
