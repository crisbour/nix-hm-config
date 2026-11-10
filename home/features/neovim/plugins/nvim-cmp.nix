{ pkgs, ... }:
with pkgs;
let
  luaPlugin = pkg: {
    type = "lua";
    plugin = pkg;
  };
in {
  home.packages = [
    nodejs # copilot-lua needes it
  ];
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (luaPlugin cmp-async-path)
      (luaPlugin cmp-fuzzy-buffer)
      (luaPlugin cmp-nvim-lsp)
      (luaPlugin cmp-nvim-lsp-signature-help)
      (luaPlugin lspkind-nvim)
      (luaPlugin luasnip)
      {
        type = "lua";
        plugin = pkgs.unstable.vimPlugins.copilot-cmp;
        config = ''
          require('copilot_cmp').setup()
        '';
      }
      # FIXME: Spell checking is disabled because it's not code aware
      #{
      #  type = "lua";
      #  plugin = cmp-spell;
      #  config = ''
      #    vim.opt.spell = true
      #    vim.opt.spelllang = { 'en_us' }
      #  '';
      #}
      {
        type = "lua";
        plugin = nvim-cmp;
        config = builtins.readFile ./config/nvim-cmp.lua;
      }
    ];
  };
}
