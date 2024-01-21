{ config, pkgs, inputs, ... }:
let
  #inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in
rec {
  # Gnome look inspired from: https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  gtk = {
    enable = true;

    # FIXME: Missing fontProfiles
    #font = {
    #  name = config.fontProfiles.regular.family;
    #  size = 12;
    #};

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };
    #theme = {
    #  name = "${config.colorscheme.slug}";
    #  package = gtkThemeFromScheme { scheme = config.colorscheme; };
    #};

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
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

  # TODO: Does this imply the gtkX.extraConfig is not needed anymore?
  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${gtk.theme.name}";
      "Net/IconThemeName" = "${gtk.iconTheme.name}";
    };
  };
}
