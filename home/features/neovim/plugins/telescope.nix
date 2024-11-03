{ pkgs, ... }:
with pkgs; {
  programs.neovim = {
    extraPackages = [ delta fd fzy ripgrep ];
    plugins = with vimPlugins; [
      which-key-nvim
      telescope-fzy-native-nvim
      {
        type = "lua";
        plugin = telescope-nvim;
        config = builtins.readFile ./lua/telescope.lua;
      }
    ];
  };
}
