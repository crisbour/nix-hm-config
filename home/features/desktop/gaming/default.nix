{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    winetricks
    #wineWowPackages.full
    wineWowPackages.waylandFull

    blender

    (lutris.override {
      extraLibraries =  pkgs: [
        vkd3d
        wine
        winetricks
        libadwaita
        gtk4
        # List library dependencies here
      ];
    })
  ];
}
