{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}:
let
  hyprlandReload = ''
    for instance in /run/user/$(id -u)/hypr/*/; do
      [ -S "$instance/.socket.sock" ] || continue
      HYPRLAND_INSTANCE_SIGNATURE=$(basename "$instance") \
        ${pkgs.hyprland}/bin/hyprctl reload || true
    done
  '';
in
{
  # Inspired from: https://github.com/Frost-Phoenix/nixos-config/tree/c151860c8e576755dc60530e2527005dbcc79750
  imports = [
    ../common

    inputs.hyprland.homeManagerModules.default

    inputs.noctalia.homeModules.default
    ./noctalia.nix

    ./variables.nix
    #./hyprlock.nix

    ./swaylock.nix
    ./hypridle.nix
    ./swaync
    ./scripts
    #./polkitagent.nix
  ];

  home.packages = with pkgs; [
    awww
    cliphist
    gnome-themes-extra
    grim
    #swappy
    grimblast
    hyprpicker
    hyprshot
    imv
    qt5.qtwayland
    qt6.qtwayland
    satty
    slurp
    tesseract
    unstable.wayland-protocols
    wayland-utils
    weston
    wf-recorder
    wl-clip-persist
    wl-clipboard
    #wl-clipboard-rs

    # polkit agent
    hyprpolkitagent
    polkit_gnome
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  services.pix2tex.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    xwayland.enable = true;
    systemd.enable = true;

    # make dbus activation inherit all variables
    systemd.variables = [ "--all" ];

    plugins = [ pkgs.hyprlandPlugins.hyprspace ];

    settings = { };

    extraConfig = ''
    require("hyprland-user")
    '';

    #extraLuaFiles = {
    #  #"hyprsplit/init" = {
    #  #  autoLoad = false;
    #  #  content = builtins.readFile "${inputs.hyprsplit.hyprsplitlua}/share/hyprsplit/init.lua";
    #  #};
    #  "hyprland-user" = {
    #    autoLoad = true;
    #    content = ./lua/hyprland.lua;
    #  };
    #  # TODO: Not sure I need this:
    #  "clamshell" = {
    #    autoLoad = false;
    #    content = ./lua/clamshell.lua;
    #  };
    #};

  };

  # HM only auto-reloads Hyprland when its own generated config changes, so
  # reload manually whenever these deployed files change. Discovers the
  # instance via the runtime dir since activation may run without session env
  # (e.g. nixos-rebuild).
  home.file.".config/hypr/hyprland-user.lua" = {
    source = ./lua/hyprland.lua;
    onChange = hyprlandReload;
  };

  #home.file.".config/hypr/clamshell.lua" = {
  #  source = ./lua/clamshell.lua;
  #  onChange = hyprlandReload;
  #};

  home.activation.createMonitorsLua = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.config/hypr/monitors.lua" ]; then
      run mkdir -p "$HOME/.config/hypr"
      run touch "$HOME/.config/hypr/monitors.lua"
    fi
  '';

}
