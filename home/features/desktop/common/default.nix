{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  #hasGui = config.wayland.enable || config.xorg.enable;
  hasGUI = true;
  # Nerdfonts is huge: take only what you need
  #nerdfonts = (pkgs.nerdfonts.override { fonts = [
  #    "FiraCode"
  #    "DroidSansMono"
  #    "Iosevka"
  #    "Monokai"
  #]; });
in
{
  imports = [
    ./gtk.nix
    ./browser.nix
    #./xdg.nix
    #./font.nix
    #./brave.nix
    #./kdeconnect.nix
  ];

  xdg.portal.enable = true;

  home.packages = with pkgs; [
    # Control fonts better
    nerdfonts

    #flameshot
    #shutter # screenshots
    xdg-utils
    xclip

    # TODO: Perhaps use these with touchscreen display laptop
    #write_stylus
    #xournal

    brightnessctl
    okular

    # TODO Move to productivity
    joplin-desktop
    mendeley

    # Move to media
    spotify

    # Graph drawing
    (import ../gui/yed.nix { inherit pkgs; })

  ];
}
