{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [

    unstable.winetricks
    unstable.wineWowPackages.full

    (lutris.override {
      extraLibraries =  pkgs: [
        libadwaita
        gtk4
        pango
        pangolin
        # List library dependencies here
      ];
    })
  ];
}
