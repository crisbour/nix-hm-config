{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    # Celeste
    celeste-classic

    # Doom
    crispy-doom

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
        pango
        pangolin
        # List library dependencies here
      ];
    })
  ];
}
