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
      size = 16;
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

    # TODO: Improve fonts configs like https://github.com/oceanlewis/nix-config/blob/e692821d3d3f77785131737707e4ce723cc68f72/programs/alacritty/fonts.nix#L61
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
          style: Italic
        bold_italic:
          family: IosevkaNerdFontMono
          style: Bold Italic
    '';

  } // lib.modules.importJSON  (./. + "/colors/my_theme.json");
}
