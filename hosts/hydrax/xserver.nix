{ config, pkgs, ... }:
{
  services.xserver.enable = true;

  environment.systemPackages = with pkgs; [
    xorg.xorgserver
    xorg.xrandr
    xorg.xinit
    xorg.xauth
    xorg.xhost
    xterm
  ];
}
