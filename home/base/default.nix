{ config, lib, pkgs, specialArgs, ... }:
with lib.hm.gvariant;
let
  # hacky way of determining which machine I'm running this from
  inherit (specialArgs) withGUI isDesktop;
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [
    ./modules
    ./programs
  ];

  home = {
    stateVersion = "23.11";
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
  };

  # Keep qemu configuration for virt-manager as shown at: https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
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
  };

  # Allow Nix to handle fonts
  fonts.fontconfig.enable = true;

  # You can add services as follows:
  #services.<program> = {
  #  enable = true;
  #  ...
  #}

  # Alternative to plain direnv, add watch method to evaluate state of shell
  services.lorri.enable = isLinux;

  services.udiskie.enable = isLinux;

  # Gnome look inspired from: https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
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

}
