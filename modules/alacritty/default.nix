{ config, lib, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      # TODO Binding fixup
      #key_bindings = [
      #  { key = "Equals";     mods = "Control";     action = "IncreaseFontSize"; }
      #  { key = "Add";        mods = "Control";     action = "IncreaseFontSize"; }
      #  { key = "Subtract";   mods = "Control";     action = "DecreaseFontSize"; }
      #  { key = "Minus";      mods = "Control";     action = "DecreaseFontSize"; }
      #];
      font =
      let
        font = "IosevkaNerdFontMono";
      in
      {
        size = 16;
        normal = {
          family = font;
          style = "Regular";
        };
        bold = {
          family = font;
          style = "Medium";
        };
        italic = {
          family = font;
          style = "Italic";
        };
        bold_italic = {
          family = font;
          style = "Medium Italic";
        };
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
        decorations = "None";
      };

      shell = if config.programs.tmux.enable
      then {
        program = pkgs.runtimeShell;
        args = ["-c" "tmux attach || tmux new"];
      } else {
        program = config.home.sessionVariables.SHELL;
      };

      colors = {
        primary = {
          background = "0x1c1e26";
          foreground = "0xcbced0";
        };

        normal = {
          black   = "0x1c1e26";
          red     = "0xe95678";
          green   = "0x29d398";
          yellow  = "0xfac29a";
          blue    = "0x26bbd9";
          magenta = "0xee64ac";
          cyan    = "0x59e1e3";
          white   = "0xcbced0";
        };

        bright = {
          black   = "0x6f6f70";
          red     = "0xe95678";
          green   = "0x29d398";
          yellow  = "0xfac29a";
          blue    = "0x26bbd9";
          magenta = "0xee64ac";
          cyan    = "0x59e1e3";
          white   = "0xe3e6ee";
        };

        cursor = {
          text   = "0x1c1e26";
          cursor = "0xcbced0";
        };

        selection = {
          text       = "0x000000";
          background = "0xb3d7ff";
        };
        dim = {
          black   = "0x000000";
          red     = "0xa90000";
          green   = "0x049f2b";
          yellow  = "0xa3b106";
          blue    = "0x530aba";
          magenta = "0xbb006b";
          cyan    = "0x433364";
          white   = "0x5f5f5f";
        };
        indexed_colors = [
          { index = 16; color = "0xfab795";}
          { index = 17; color = "0xf09383";}
          { index = 18; color = "0x232530";}
          { index = 19; color = "0x2e303e";}
          { index = 20; color = "0x9da0a2";}
          { index = 21; color = "0xdcdfe4";}
        ];
      };

      # TODO: Improve fonts configs like https://github.com/oceanlewis/nix-config/blob/e692821d3d3f77785131737707e4ce723cc68f72/programs/alacritty/fonts.nix#L61
    };
  };
}
