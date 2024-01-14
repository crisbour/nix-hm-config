{ pkgs, ... }:
with pkgs;
let
  inherit stdenv fetchFromGitLab writeText vim vimUtils;
  vim-codal-lang = vimUtils.buildVimPlugin rec {
    version = "v0.1";
    #versionSuffix = "pre${toString src.revCount or 0}.${src.shortRev or "0000000"}";
    pname = "vim-codal-${version}";
    src = ./.;
    meta = with pkgs.lib; {
      description = "Codal Vim Syntax Highlighting Plugin";
    };
  };
in
{
  programs.neovim = {
    plugins = [
      {
        plugin = vim-codal-lang;
        config = ''
          au BufRead,BufNewFile *.codal set filetype=codal
          au BufRead,BufNewFile *.hcodal set filetype=codal

          au FileType codal set tabstop=4 shiftwidth=4 expandtab

          " Proper "ifdef" handling
          au FileType codal set syntax=codal.ifdef
        '';
      }
    ];
  };
}

