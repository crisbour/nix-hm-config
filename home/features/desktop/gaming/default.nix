{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    winetricks
    #wineWowPackages.full
    wineWowPackages.waylandFull

    (lutris.override {
      extraLibraries =  pkgs: [
        vkd3d
        wine
        winetricks
        libadwaita
        gtk4
        blender
        # List library dependencies here
      ];
    })
  ];
}
