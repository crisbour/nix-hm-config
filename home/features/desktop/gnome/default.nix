{pkgs, ...}: {
  imports = [
    ../common
    #./extensions
  ];

  #services.xsettingsd.enable = false; # To overwrite the default (enable = true) from gtk.nix

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "Alacritty.desktop"
        "brave-browser.desktop"
        "spotify.desktop"
        #"discord.desktop"
        #"code.desktop"
        #"slack.desktop"
        #"thunderbird.desktop"
        #"org.telegram.desktop.desktop"
        #"org.gnome.Nautilus.desktop"
      ];
    };

    # Keep qemu configuration for virt-manager as shown at: https://nixos.wiki/wiki/Virt-manager
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      # cursor-size = 33;
    };

    #"org/gnome/mutter" = {
    #  workspaces-only-on-primary = true;
    #};

    #"org/gnome/settings-daemon/plugins/media-keys" = {
    #  custom-keybindings = [
    #    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-alacritty/"
    #    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-rofi/"
    #  ];
    #};
    #"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-alacritty" = {
    #  binding = "<Super>Return";
    #  command = "alacritty";
    #  name = "open-terminal";
    #};
    #"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-rofi" = {
    #  binding = "<Super>D";
    #  command = "rofi -show drun";
    #  name = "rofi-drun";
    #};
  };
}
