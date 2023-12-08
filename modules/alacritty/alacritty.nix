{ config, lib, pkgs, ... }:
withGUI:
let
  termfont = {family = "MesloLGS Nerd Font";};
in {
  enable = withGUI;
  settings = {
    keybindings = [
      { key = "Equals";     mods = "Control";     action = "IncreaseFontSize"; }
      { key = "Add";        mods = "Control";     action = "IncreaseFontSize"; }
      { key = "Subtract";   mods = "Control";     action = "DecreaseFontSize"; }
      { key = "Minus";      mods = "Control";     action = "DecreaseFontSize"; }
    ];
    font = {
      size = 12;
    };

    cursor = {
      style = "Beam";
      thickness = 0.2;
    };
    window = {
      dimensions = {
        columns = 140;
        lines = 40;
      };
      decorations = "none";
    };

    shell = if config.programs.tmux.enable
    then {
      program = pkgs.runtimeShell;
      args = ["-c" "tmux attach || tmux new"];
    } else {
      program = config.home.sessionVariables.SHELL;
    };

    decorations_theme_variant = "dark";

    extraConfig = ''
      font:
        normal:
          family: IosevkaNerdFontMono
          style: Regular
        bold:
          family: IosevkaNerdFontMono
          style: Bold
        italic:
          family: IosevkaNerdFontMono
          style: Bold
        bold_italic:
          family: IosevkaNerdFontMono
          style: Bold Italic
    '';

  } // lib.modules.importJSON  (./. + "/colors/my_theme.json");
}
