# Cool other configs to look at
# - http://www.lukesmith.xyz/conf/.vimrc
# - https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
# - https://github.com/jschomay/.vim/blob/master/vimrc
# - https://github.com/jhgarner/DotFiles

{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    #./clipboard.nix
    ./plugins
    #./shortcuts.nix
    ./theme.nix
  ];

  programs.neovim = {
    enable = true;

    extraConfig = concatMapStringsSep "\n\n" builtins.readFile [
      ./init.vim
      ./filetype-specific-configs.vim
    ];

    # Toggle LSP diagnostics of errors to make text readable
    extraLuaConfig = ''
      lsp_diagnostics_enabled = true  -- Track the state of diagnostics

      function toggle_lsp_diagnostics()
          lsp_diagnostics_enabled = not lsp_diagnostics_enabled  -- Toggle the state
          vim.diagnostic.config({
              underline = lsp_diagnostics_enabled, -- Set underline based on the state
              virtual_text = lsp_diagnostics_enabled, -- Set virtual text based on the state
              virtual_line = lsp_diagnostics_enabled, -- Set virtual line based on the state
          })
          print("LSP Diagnostics is now " .. (lsp_diagnostics_enabled and "enabled" or "disabled"))
      end

      -- Map the toggle function to a key combination, e.g., <leader>td
      vim.api.nvim_set_keymap('n', '<leader>td', ':lua toggle_lsp_diagnostics()<CR>', { noremap = true, silent = true })
    '';

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withPython3 = true;
    withNodeJs = true;
    withRuby = true;
  };

  # TODO:Add spelling suggestions
  #home.symlinks."${config.xdg.configHome}/nvim/spell/en.utf-8.add" =
  #  "${config.home.homeDirectory}/Syncthing/.config/nvim/spell/en.utf-8.add";
}
