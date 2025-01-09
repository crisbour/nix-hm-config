{ config, pkgs, inputs, ... }:
let
  #inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in
{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "NerdFontsSymbolsOnly" ]; })
    twemoji-color-font
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    maple-mono
  ];
  # Gnome look inspired from: https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  gtk = {
    enable = true;

    # FIXME: Missing fontProfiles
    font = {
      #name = config.fontProfiles.regular.family;
      name = "NotoSansMono Nerd Font";
      size = 12;
    };

    theme = {
      name = "Colloid-Green-Dark-Gruvbox";
      package = pkgs.colloid-gtk-theme.override {
        colorVariants = [ "dark" ];
        themeVariants = [ "green" ];
        tweaks = [
          "gruvbox"
          "rimless"
          "float"
        ];
      };
    };
    #theme = {
    #  name = "${config.colorscheme.slug}";
    #  package = gtkThemeFromScheme { scheme = config.colorscheme; };
    #};

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "black"; };
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # FIXME: Prefer gtk-application-prefer-dark-theme appearing as "Settings" instead of native parameter in /home/cristi/.config/gtk-{3,4}.0/settings.ini
    #  Unknown key Settings in /home/cristi/.config/gtk-3.0/settings.ini
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=true;
    };
  };

  home.pointerCursor = {
    #gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };


}
