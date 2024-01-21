{ pkgs, ... }:
{
  programs.neovim = {
    extraPackages = with pkgs; [
      lua-language-server
      rnix-lsp                      # Nix language server
      rust-analyzer
      clang-tools_17
      texlab
    ] ++ (with pkgs.nodePackages; [
      pyright
    ]);
    plugins = with pkgs.vimPlugins; [
      {
        type = "lua";
        plugin = nvim-lspconfig;
        config = ''
        local lspconfig = require('lspconfig')
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        lspconfig.bashls.setup {
          cmd = { "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start" },
          capabilities = capabilities,
        }
        lspconfig.clangd.setup {
          cmd = { "${pkgs.clang-tools_17}/bin/clangd",
                  "--all-scopes-completion",
                  "--suggest-missing-includes",
                  "--background-index",
                  "--log=info",
                  "--clang-tidy",
                  "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*,modernize-*,-modernize-use-trailing-return-type",
                  "--enable-config",
                  },
          capabilities = capabilities,
        }
        lspconfig.cmake.setup{
          capabilities = capabilities,
        }
        lspconfig.julials.setup{
          capabilities = capabilities,
        }
        lspconfig.nixd.setup{
          capabilities = capabilities,
        }
        --lspconfig.nimls.setup{}
        --lspconfig.pyls.setup{}
        lspconfig.pyright.setup{
          capabilities = capabilities,
        }
        lspconfig.rust_analyzer.setup{
          capabilities = capabilities,
          settings = {
            ['rust-analyzer'] = {},
          },
        }
        lspconfig.vimls.setup{
          capabilities = capabilities,
        }
        lspconfig.veridian.setup{
          capabilities = capabilities,
        }
        lspconfig.yamlls.setup {
          cmd = { "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server", "--stdio" },
          capabilities = capabilities,
        }
        lspconfig.texlab.setup {
            cmd = { "${pkgs.texlab}/bin/texlab" },
            capabilities = capabilities,
          }


        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<C-h>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<space>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
          end,
        })

        local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
        local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

        -- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = 'rounded',
          max_width = max_width,
          max_height = max_height,
        })

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = 'rounded',
          max_width = max_width,
          max_height = max_height,
        })
        '';
      }
    ];
  };
}
