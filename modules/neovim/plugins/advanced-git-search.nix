{ pkgs, ... }:
with pkgs;
let
  inherit stdenv fetchFromGitLab writeText vim vimUtils;
  nvim-ags = vimUtils.buildVimPlugin rec {
    version = "master";
    #versionSuffix = "pre${toString src.revCount or 0}.${src.shortRev or "0000000"}";
    pname = "advanced-git-search-nvim-${version}";
    src = fetchFromGitLab {
      owner = "aaronhallaert";
      repo = "advanced-git-search.nvim";
      rev = "main";
      sha256 = "";
    };
    meta.homepage = "https://github.com/aaronhallaert/advanced-git-search.nvim.git";
  };
in
{
  programs.neovim = {
    plugins = [
      nvim-ags
    ];
  };
}

