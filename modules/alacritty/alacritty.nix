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
  } // lib.trivial.importJSON  (./. + "./colors/my_theme.yaml";
}
