{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quarto
  ];

  programs.neovim = {
    extraPackages = [
    ];
    extraPython3Packages = pyPkgs: with pyPkgs; [
      # for molten-nvim
      jupyter-client
      pyperclip
      nbformat
    ];
    plugins = with pkgs.vimPlugins; [
      image-nvim # for image rendering
      molten-nvim
      image-nvim
      nvim-lspconfig
      otter-nvim
      {
        type = "lua";
        plugin = quarto-nvim;
        config = ''
          require('lspconfig')
          require("otter").setup({
            lsp = {
              enabled = true,
            },
          })
          local quarto = require('quarto')
          quarto.setup({
            lspFeatures = {
              languages = { "r", "python", "julia", "bash", "lua", "html", "rust" },
              chunks = "all",  -- or curly
              diagnostics = {
                enabled = true,
                triggers = { "BufWritePost" },
              },
              completion = {
                enabled = true,
              },
            },
            codeRunner = {
              enabled = true,
              default_method = "molten",
            },
          })
          local runner = require("quarto.runner")
          vim.keymap.set('n', '<leader>qp', quarto.quartoPreview, { silent = true, noremap = true })
          vim.keymap.set("n", "<leader>rc", runner.run_cell,  { desc = "run cell", silent = true })
          vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell and above", silent = true })
          vim.keymap.set("n", "<leader>rA", runner.run_all,   { desc = "run all cells", silent = true })
          vim.keymap.set("n", "<leader>rl", runner.run_line,  { desc = "run line", silent = true })
          vim.keymap.set("v", "<leader>r",  runner.run_range, { desc = "run visual range", silent = true })
        '';
      }
    ];
  };
  home.file.".config/nvim/ftplugin/markdown.lua".text = ''
    require("quarto").activate()
  '';
}
