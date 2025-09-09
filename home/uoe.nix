{ inputs, outputs, lib, pkgs, ... }:
{
  imports = [
    ./base
    ./features/auth
    ./features/desktop/alacritty
    #./features/desktop/gnome
    ./features/desktop/hyprland
    ./features/devtools
    ./features/productivity
    ./features/desktop/channels
    ./features/desktop/electronics
    ./features/desktop/gaming # Wine apps
    ./features/pass
    ./features/nfs
  ];

  home = {
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
    user-info = {
      username      = "cristi";
      fullName      = "Cristian Bourceanu";
      email         = "v.c.bourceanu@sms.ed.ac.uk";
      github        = "crisbour";
      #gitlab        = "s2703496";
      gpg.enable    = true;
      gpg.masterKey = "0xAEF4A543011E8AC1";
      gpg.signKey   = "0xA6307A244F3BD76D";
      # FIXME: Extract has_gui from nixos/host config instead
      has_gui      = true;
    };
  };

  home.packages = with pkgs; [
    # WARN: I only need this for Fusion360, perhaps isolate it more specifically in the top config
    flatpak
  ];

  # FIXME: Make profiles and include them in home/features/desktop/hyprland/config.nix instead
  wayland.windowManager.hyprland = {
    settings = {
      workspace = [
        "1, monitor:DP-3, default:true"
        "2, monitor:DP-2"
      ];
    };

    extraConfig = "
      #monitor = HDMI-A-4, 1920x1080, 0x0, 1
      monitor = DP-2, 1920x1080, 0x0, 1
      monitor = DP-3, 1920x1200, 1920x0, 1

      # Make sure no scaling is applied to main display
      #monitor=eDP-1,preferred,auto,1
      #monitor = DP-2, preferred,auto,1.5

      xwayland {
        force_zero_scaling = true
      }
    ";
  };

}
