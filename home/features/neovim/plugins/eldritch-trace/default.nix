{ pkgs, ... }:
with pkgs;
let
  inherit stdenv fetchFromGitLab writeText vim vimUtils;
  vim-eldritch-trace-lang = vimUtils.buildVimPlugin rec {
    version = "v0.5.3";
    #versionSuffix = "pre${toString src.revCount or 0}.${src.shortRev or "0000000"}";
    pname = "vim-eldritch-trace-${version}";
    src = ./.;
    meta = with pkgs.lib; {
      description = "Eldritch-Trace Syntax Highlighting Plugin";
    };
  };
in
{
  programs.neovim = {
    plugins = [
      {
        plugin = vim-eldritch-trace-lang;
        type = "viml";
        config = ''
          au BufRead,BufNewFile *.et set filetype=eldritch-trace
          au FileType eldritch-trace set tabstop=4 shiftwidth=4 expandtab nospell
        '';
      }
    ];
  };
}

