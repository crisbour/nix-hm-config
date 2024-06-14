{ pkgs, ... }:
with pkgs;
let
  inherit stdenv fetchFromGitHub writeText vim vimUtils;
  nvim-advanced-git-search = vimUtils.buildVimPlugin rec {
    name = "advanced-git-search-nvim";
    src = fetchFromGitHub {
      owner = "aaronhallaert";
      repo = "advanced-git-search.nvim";
      rev = "main";
      sha256 = "sha256-IoMu2xgl7OyxSrjcJ0XlbGQEO7d/vbOk459/6tsaSv0=";
    };
    meta.homepage = "https://github.com/aaronhallaert/advanced-git-search.nvim.git";
  };
in
{
  programs.neovim.plugins = [
    nvim-advanced-git-search
  ];
}

