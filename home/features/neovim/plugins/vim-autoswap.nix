# Swap to the already opened file
{ pkgs, ... }:
with pkgs; {
  programs.neovim = {
    extraPackages = [ wmctrl ];
    plugins = [{
      plugin = vimPlugins.vim-autoswap;
      config = ''
        vim.g.autoswap_detect_tmux = 1
      '';
    }];
  };
}
