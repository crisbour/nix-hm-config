{ pkgs, ... }:
with pkgs;
let
  inherit stdenv fetchFromGitLab writeText vim vimUtils;
  vim-spade-lang = vimUtils.buildVimPlugin rec {
    version = "master";
    #versionSuffix = "pre${toString src.revCount or 0}.${src.shortRev or "0000000"}";
    pname = "vim-spade-${version}";
    src = fetchFromGitLab {
      owner = "spade-lang";
      repo = "spade-vim";
      rev = "d658a2eec0175c252827e39049cae7a7324d42dd";
      sha256 = "sha256-YneRALZT6QrBMXNQ2rVZxBWju4R57dTeYvc5PlqeRQ0=";
    };
    meta.homepage = "https://gitlab.com/spade-lang/spade-vim";
  };
in
{
  programs.neovim.plugins = [
    {
      plugin = vim-spade-lang;
      config = ''
        au BufRead,BufNewFile *.spade set filetype=spade
      '';
    }
  ];
}

