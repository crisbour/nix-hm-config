{ pkgs, ... }:
with pkgs;
let
  inherit stdenv fetchFromGitHub writeText vim vimUtils;
  nvim-advanced-git-search = vimUtils.buildVimPlugin rec {
    name = "advanced-git-search-nvim";
    version = "v1.2.0";
    src = fetchFromGitHub {
      owner = "aaronhallaert";
      repo = "advanced-git-search.nvim";
      rev = "198cc402af1790ab26830fdbf24a28c336a20ba6";
      sha256 = "sha256-IyvTbplqBrM7ELK9XC9uOWOcsP/I/sjVOG01tzZe0Hc=";
    };
    meta.homepage = "https://github.com/aaronhallaert/advanced-git-search.nvim.git";
  };
in
{
  programs.neovim.plugins = [
    nvim-advanced-git-search
  ];
}

