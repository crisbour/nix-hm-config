{ pkgs, ... }: {
  programs.neovim.plugins = [{
    type = "lua";
    plugin = pkgs.vimPlugins.conform-nvim;
    config = ''
      require("conform").setup({
        formatters_by_ft = {
          go = { "goimports" },
          markdown = { "deno_fmt" },
          nix = { "nixfmt" },
        },
        formatters = {
          deno_fmt = { command = "${pkgs.deno}/bin/deno" },
          goimports = { command = "${pkgs.gotools}/bin/goimports" },
          nixfmt = { command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt" },
        },
      })
      vim.keymap.set('n', '<C-f>', function()
        require("conform").format {
          lsp_fallback = "always",
          timeout_ms = 5000,
        }
      end, opts)
    '';
  }];
}
