{ inputs, pkgs, ... }: {

  wayland.windowManager.hyprland = {
    plugins = [ pkgs.hyprlandPlugins.hyprspace ];
    settings = {
      plugin = { overview = { autoDrag = false; }; };

      bind = [
        #"$mainMod,TAB, overview:toggle" # Overview
      ];
    };
  };
}
