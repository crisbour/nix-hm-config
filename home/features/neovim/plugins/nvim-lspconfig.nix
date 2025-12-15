{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ltex-ls
    svls
    verible
  ];
  programs.neovim = {
    extraPackages = with pkgs; [
      clang-tools
      #spade-language-server
      nixd # Nix language server
      ltex-ls
      lua-language-server
      matlab-language-server
      ruff
      pyright
      rust-analyzer
      svls
      texlab
      verible
      vim-language-server
      zls
      nodePackages.vscode-json-languageserver
    ] ++ (with pkgs.nodePackages; [
      pyright
    ]);
    plugins = with pkgs.vimPlugins; [
      {
        type = "lua";
        plugin = nvim-lspconfig;
        config = ''
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        vim.lsp.enable('bashls')
        vim.lsp.config('bashls', {
          cmd = { "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start" },
          capabilities = capabilities,
        })

        vim.lsp.enable('clangd')
        vim.lsp.config('clangd', {
          cmd = { "${pkgs.clang-tools}/bin/clangd",
                  "--all-scopes-completion",
                  "--suggest-missing-includes",
                  "--background-index",
                  "--log=info",
                  "--clang-tidy",
                  "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*,modernize-*,-modernize-use-trailing-return-type",
                  "--enable-config",
                  },
          capabilities = capabilities,
        })

        vim.lsp.enable('cmake')
        vim.lsp.config('cmake',{
          capabilities = capabilities,
        })

        vim.lsp.enable('julials')
        vim.lsp.config('julials',{
          capabilities = capabilities,
          cmd = { "${pkgs.nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver", "--stdio" },
        })

        vim.lsp.enable('julials')
        vim.lsp.config('julials',{
          capabilities = capabilities,
        })

        vim.lsp.enable('ltex')
        vim.lsp.config('ltex',{
          settings = {
            ltex = {
              language = "en-GB",
              -- Supported languages: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ltex
              filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "tex", "pandoc", "quarto", "html", "xhtml" },
            },
          },
          capabilities = capabilities,
        })

        vim.lsp.enable('matlab_ls')
        vim.lsp.config('matlab_ls',{
          capabilities = capabilities,
        })

        vim.lsp.enable('nixd')
        vim.lsp.config('nixd',{
          capabilities = capabilities,
        })

        --vim.lsp.enable('nimls')
        --vim.lsp.config('nimls',{})
        --lspconfig.pyls.setup{}

        vim.lsp.enable('ruff')
        vim.lsp.config('ruff',{
          capabilities = capabilities,
        })

        vim.lsp.enable('pyright')
        vim.lsp.config('pyright',{
          capabilities = capabilities,
        })

        vim.lsp.enable('rust_analyzer')
        vim.lsp.config('rust_analyzer', {
          capabilities = capabilities,
          settings = {
            ['rust-analyzer'] = {},
          },
        })

        vim.lsp.enable('vimls')
        vim.lsp.config('vimls',{
          capabilities = capabilities,
        })

        --vim.lsp.enable('veridian')
        --vim.lsp.config('veridian',{
        --  capabilities = capabilities,
        --})

        vim.lsp.enable('svls')
        vim.lsp.config('svls',{
          capabilities = capabilities,
        })
        vim.lsp.enable('verible')
        vim.lsp.config('verible',{
          capabilities = capabilities,
        })

        vim.lsp.enable('yamlls')
        vim.lsp.config('yamlls', {
          cmd = { "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server", "--stdio" },
          capabilities = capabilities,
        })

        vim.lsp.enable('texlab')
        vim.lsp.config('texlab', {
          cmd = { "${pkgs.texlab}/bin/texlab" },
          capabilities = capabilities,
        })

        vim.lsp.enable('zls')
        vim.lsp.config('zls', {
          capabilities = capabilities,
        })

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Some Lsp servers do not advertise inlay hints properly so enable this keybinding regardless
            vim.keymap.set('n', '<space>ht', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({bufnr = 0}), { bufnr = 0 })
              end,
              { desc = '[H]ints [T]oggle', noremap=true, buffer=bufnr }
            )

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
