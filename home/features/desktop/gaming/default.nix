{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [

    winetricks
    wineWowPackages.full

    (lutris.override {
      extraLibraries =  pkgs: [
        vkd3d
        wine
        winetricks
        libadwaita
        gtk4
        pango
        pangolin
        # List library dependencies here
      ];
    })
  ];
}
