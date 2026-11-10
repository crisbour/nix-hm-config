{ pkgs, ... }: {
  programs.neovim.plugins = [{
    type = "lua";
    plugin = pkgs.vimPlugins.conform-nvim;
    config = builtins.readFile ./config/conform-nvim.lua;
  }];
}
