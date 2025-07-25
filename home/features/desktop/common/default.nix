{ pkgs, config, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  hasGUI = config.home.user-info.has_gui;
  # Nerdfonts is huge: take only what you need
  #nerdfonts-subset = (pkgs.nerdfonts.override { fonts = [
  #    "FiraCode"
  #    "DroidSansMono"
  #    "Iosevka"
  #    "Monokai"
  #    "NotoSans"
  #]; });
in
{
  imports = [
    ./gtk.nix
    ./rofi.nix
    ./browser.nix
    ./xdg.nix
    #./font.nix

    ./gui/remote.nix
    ./kitty.nix

    #./calendar

    #./communication.nix
    # Not sure I need this
    #./syncthing.nix
  ];

  # TODO What is xdg portal and configure it to gtk or kde?
  #xdg.portal.enable = true;

  services.yubikey-touch-detector.enable = true;

  home.packages = with pkgs; [
    # Control fonts better
    #nerdfonts-subset
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

    # Graph drawing
    # WARN Broken
    #(import ./gui/yed.nix { inherit pkgs; }) # yEd for HiDPI

    # Image editing
    gimp
    inkscape

    # Image viewer
    oculante

    # Terminal emulator
    ghostty

    # File manager
    nemo

    # Media player
    mpv

    audacious
    file-roller # archive

    obs-studio
    pavucontrol                       # pulseaudio volume controle (GUI)
    resources                         # GUI resources monitor
    zenity
  ];
}
