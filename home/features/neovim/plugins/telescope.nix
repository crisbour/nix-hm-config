{ pkgs, ... }:
let
  #telescope-zotero-nvim = pkgs.vimUtils.buildVimPlugin
  #{
  #  name = "telescope-zotero-nvim";
  #  src = pkgs.fetchFromGitHub {
  #    owner = "jmbuhr";
  #    repo = "telescope-zotero.nvim";
  #    rev = "42afd2dc191cf469fb0d42b713494f1b20cffef6";  # Check GitHub for latest
  #    hash = "sha256-DASwjirbzEzEFVtd1oLwJVVHuZ0jAY2NLlc5LEfrjF8="; # Get via nix-prefetch-github
  #  };
  #};
  telescope-zotero-nvim = pkgs.vimUtils.buildVimPlugin
  {
    name = "telescope-zotero-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "jmbuhr";
      repo = "telescope-zotero.nvim";
      rev = "74f7e5464461dd4325cb843cf801158937a52020";  # Check GitHub for latest
      hash = "sha256-XMXnAcetIaqkMr8d/p6ATBckccbMj2vaO/RIH66ShwA="; # Get via nix-prefetch-github
    };
    doCheck = false;
    disableRequireCheck = true;
  };
in
with pkgs; {
  programs.neovim = {
    extraPackages = [ delta fd fzy ripgrep sqlite ];
    plugins = with vimPlugins; [
      telescope-fzy-native-nvim
      {
        type = "lua";
        plugin = telescope-nvim;
        config = builtins.readFile ./lua/telescope.lua;
      }
      sqlite-lua
      {
        type = "lua";
        # Telescope Zotero plugin: https://github.com/jmbuhr/telescope-zotero.nvim
        plugin = telescope-zotero-nvim;
        config = ''
          local telescope = require('telescope')
          telescope.load_extension('zotero')

          vim.g.maplocalleader = ';'
          vim.keymap.set("n", "<localleader>fr", ':Telescope zotero<cr>',  { desc = "Find reference" })
        '';
      }
    ];
  };
}
