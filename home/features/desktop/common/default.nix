{ pkgs, config, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  hasGUI = config.home.user-info.has_gui;
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
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.nerd-fonts.fira-code # Extension for enlarged operators
    nerd-fonts.iosevka
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji

    #flameshot
    #shutter # screenshots
    xdg-utils
    xclip

    # TODO: Perhaps use these with touchscreen display laptop
    #write_stylus
    #xournal

    brightnessctl

    kdePackages.okular

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
    obs-studio-plugins.wlrobs
    pavucontrol                       # pulseaudio volume controle (GUI)
    resources                         # GUI resources monitor
    zenity
  ];
}
