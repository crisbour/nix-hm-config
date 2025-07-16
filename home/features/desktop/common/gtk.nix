{ config, pkgs, inputs, ... }:
let
  #inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in
{
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    maple-mono
  ];
  # Gnome look inspired from: https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  gtk = {
    enable = true;

    # FIXME: Prefer gtk-application-prefer-dark-theme appearing as "Settings" instead of native parameter in /home/cristi/.config/gtk-{3,4}.0/settings.ini
    #  Unknown key Settings in /home/cristi/.config/gtk-3.0/settings.ini
      #gtk3.extraConfig = {
      #  gtk-application-prefer-dark-theme=true;
      #};

      #gtk4.extraConfig = {
      #  gtk-application-prefer-dark-theme=true;
      #};
  };

}
