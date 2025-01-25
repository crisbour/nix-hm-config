{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpolkitagent
    polkit_gnome
  ];

  wayland.windowManager.hyprland.settings.exec-once = [
    # Elevate permissions
    "systemctl --user start hyprpolkitagent"
  ];
}
