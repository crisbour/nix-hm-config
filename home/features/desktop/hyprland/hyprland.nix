{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    swww
    grimblast
    hyprpicker
    imv
    grim
    slurp
    wl-clip-persist
    cliphist
    wl-clipboard
    #wl-clipboard-rs
    wf-recorder
    wayland-utils
    wayland-protocols
    gnome-themes-extra
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
  };
}
