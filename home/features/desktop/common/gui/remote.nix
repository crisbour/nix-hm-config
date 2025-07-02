# Desktop remote interface and setup for server and client
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    remmina
    realvnc-vnc-viewer
    freerdp
  ];
}
