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
        "discord.desktop"
        "slack.desktop"
        "org.gnome.Nautilus.desktop"
        #"code.desktop"
        #"thunderbird.desktop"
        #"org.telegram.desktop.desktop"
        #"org.gnome.Nautilus.desktop"
      ];
      enabled-extensions = [
        "trayIconsReloaded@selfmade.pl"
        "Battery-Health-Charging@maniacx.github.com"
        #"blur-my-shell@aunetx"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        #"dash-to-panel@jderose9.github.com"
        "just-perfection-desktop@just-perfection"
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "horizontal-workspace-indicator@tty2.io"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "gsconnect@andyholmes.github.io"
        #"pip-on-top@rafostar.github.com"
        "forge@jmmaranan.com"
        # "dash-to-dock@micxgx.gmail.com" # Alternative Dash-to-Panel
        # "fullscreen-avoider@noobsai.github.com" # Dash-to-Panel Incompatable
      ];
    };

    # Keep qemu configuration for virt-manager as shown at: https://nixos.wiki/wiki/Virt-manager
    #"org/virt-manager/virt-manager/connections" = {
    #  autoconnect = ["qemu:///system"];
    #  uris = ["qemu:///system"];
    #};

   "org/gnome/mutter" = {
     edge-tiling = false;
     #experimental-features = ["scale-monitor-framebuffer"];
     workspaces-only-on-primary = false;
   };

    "org/gnome/desktop/wm/preferences"  = {
      num-workspaces = 4;
      workspace-names = [ "Hardware" "PhD" "Programming" "Nix" ];
    };

    "org/gnome/shell/extensions/horizontal-workspace-indicator" = {
      widget-position = "left";
      widget-orientation = "horizontal";
      icons-style = "circles";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      # cursor-size = 33;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/calendar" = {
        show-weekdate = true;
    };

    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = true;
      restore-state = true;
      show-indicator = true;
      show-notification = false;
    };

    #"org/gnome/shell/extensions/just-perfection" = {
    #  panel-size = 48;
    #  activities-button = false;
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


  home.packages = (with pkgs.gnomeExtensions; [
      tray-icons-reloaded
      #blur-my-shell
      removable-drive-menu
      #dash-to-panel
      upower-battery
      just-perfection
      caffeine
      clipboard-indicator
      workspace-indicator-2
      bluetooth-quick-connect
      gsconnect
      #pip-on-top
      #pop-shell
      forge
      # fullscreen-avoider
      # dash-to-dock
    ]) ++ (with pkgs; [
      #gnome-extension-manager
    ]);
}
# Good resource for customizing gnome through dconf: https://github.com/MatthiasBenaets/nixos-config/blob/020e93e22bdce9000db6ac31753dfec9c4e1c879/modules/desktops/gnome.nix#L70
