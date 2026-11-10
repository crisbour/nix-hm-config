# Tree Sitter
{ pkgs, ... }: {
  programs.neovim.plugins = [{
    type = "lua";
    plugin = pkgs.vimPlugins.trouble-nvim;
    config = builtins.readFile ./config/trouble-nvim.lua;
  }];
}
