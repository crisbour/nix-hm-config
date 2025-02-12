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
    ./features/desktop/gaming
    ./features/pass
    ./features/nfs

    # Services
    ./services/system/power-monitor.nix
    ./services/media/playerctl.nix
  ];

  home = {
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
    user-info = {
      username      = "cristi";
      fullName      = "Cristi Bourceanu";
      email         = "bourceanu.cristi@gmail.com";
      github        = "crisbour";
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
    extraConfig = "
      monitor=,preferred,auto,auto

      # Make sure no scaling is applied to main display
      monitor=eDP-1,preferred,auto,1
      monitor = DP-2, preferred,auto,1.5

      xwayland {
        force_zero_scaling = true
      }
    ";
  };

}
