{ inputs, pkgs, ... }: {

  wayland.windowManager.hyprland = {
    plugins = [ pkgs.hyprlandPlugins.hyprspace ];
    configType = "hyprlang";
    settings = {
      plugin = { overview = { autoDrag = false; }; };

      bind = [
        "SUPER, TAB, overview:toggle" # Overview
      ];
    };
  };
}
