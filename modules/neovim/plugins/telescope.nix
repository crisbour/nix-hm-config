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
      {
        type = "lua";
        plugin = telescope-undo-nvim;
        config = ''
          -- Undo tree for when I am lazy about git commits
          require('telescope').setup {
          extensions = {
            undo = {
              side_by_side = true,
            },
          },
          }
          telescope.load_extension("undo")

          vim.keymap.set('n', '<S-U>', telescope.extensions.undo.undo, {})
        '';
      }
    ];
  };
}
