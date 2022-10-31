lib: withGUI:
{
  enable = withGUI;
  settings = {
    keybindings = [
      { key = "Equals";     mods = "Control";     action = "IncreaseFontSize"; }
      { key = "Add";        mods = "Control";     action = "IncreaseFontSize"; }
      { key = "Subtract";   mods = "Control";     action = "DecreaseFontSize"; }
      { key = "Minus";      mods = "Control";     action = "DecreaseFontSize"; }
    ];
	fonts = {
      normal = termfont;
      bold = termfont;
      italic = termfont;
      bold_italic = termfont;
      size = "12";
    };

    cursor = {
      style = "Beam";
      thickness = 0.2;
    };

    shell = if config.programs.tmux.enable
    then {
      program = pkgs.runtimeShell;
      args = ["-c" "tmux attach || tmux new"];
    } else {
      program = config.home.sessionVariables.SHELL;
    };

	decorations_theme_variant = "dark";

  } // lib.modules.importJSON  (./. + "/colors/my_theme.json");
}
