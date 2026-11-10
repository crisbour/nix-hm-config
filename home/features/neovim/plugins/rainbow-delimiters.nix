{ pkgs, ... }: {
  programs.neovim.plugins = [{
    type = "lua";
    plugin = pkgs.vimPlugins.rainbow-delimiters-nvim;
    config = builtins.readFile ./config/rainbow-delimiters-nvim.lua;
  }];
}
