{ pkgs, ... }:
{
  #TODO: If necessary create nvim flake: https://primamateria.github.io/blog/neovim-nix/
  imports = [
    ./barbar.nix
    # Custom plugins
    ## Spade-lang syntax higlight
    ./spade/spade-vim.nix
    ./codal

    # Local Environment Configuration and Integration
    ./vim-autoswap.nix
    ## Use different indentation per project with vim-localvimrc
    ## vim-rooter: https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/


    # Editor
    ./nvim-neoclip.nix
    ./telescope.nix
    # FIXME Fails to build
    #./advanced-git-search.nix

    # Language Server, Completion, and Formatting
    ## Format code: ./conform.nvim.nix
    ./conform.nvim.nix
    ./nvim-cmp.nix
    ./nvim-lspconfig.nix
    ./trouble.nvim.nix
    # TODO: Performance annotations to add -> https://github.com/t-troebst/perfanno.nvim

    # Synatx Highlighting
    ./rainbow-delimiters.nix
    ./tree-sitter.nix

  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # Local Environment Configuration and Integration
    direnv-vim

    # Editor
    vim-suda
    vim-closetag
    vim-surround
    vim-visual-multi

    quarto-nvim

    # git
    fugitive

    # TODO: Use format rules across text editors
    editorconfig-vim

    # Syntax highlighting
    vim-nix         # Nix
    vim-markdown    # Markdown
    vim-toml        # TOML
    semshi          # Python

    # Julia
    julia-vim

    otter-nvim

    {
      type = "lua";
      plugin = quarto-nvim;
      config = ''
        local quarto = require('quarto')
        quarto.setup({
          lspFeatures = {
            languages = { "r", "python", "julia", "bash", "lua", "html", "dot", "javascript", "typescript", "ojs" },
            chunks = "all",
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
        -- vim.keymap.set("n", "<leader>rc", runner.run_cell,  { desc = "run cell", silent = true })
        -- vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell and above", silent = true })
        -- vim.keymap.set("n", "<leader>rA", runner.run_all,   { desc = "run all cells", silent = true })
        -- vim.keymap.set("n", "<leader>rl", runner.run_line,  { desc = "run line", silent = true })
        -- vim.keymap.set("v", "<leader>r",  runner.run_range, { desc = "run visual range", silent = true })
        -- vim.keymap.set("n", "<leader>RA", function()
        --   runner.run_all(true)
        --   end, { desc = "run all cells of all languages", silent = true })
      '';
    }

    {
      type = "lua";
      plugin = nvim-tree-lua;
      config = ''
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true

        -- empty setup using defaults
        --require("nvim-tree").setup()

        -- OR setup with some options
        require("nvim-tree").setup({
          sort = {
            sorter = "case_sensitive",
          },
          view = {
            width = 30,
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          },
        })

        vim.keymap.set({'n','i','v'}, "<A-t>", "<cmd> NvimTreeToggle<cr>",   { desc = "Toggle nvim tree" })
      '';
    }

    {
      plugin = vim-easy-align;
      config = ''
        " EasyAlign Keymaps
        " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)
        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)

        " EasyAlign Delimiter
        if !exists('g:easy_align_delimiters')
          let g:easy_align_delimiters = {}
        endif
        let g:easy_align_delimiters['d'] = {
        \ 'pattern': ' \ze\S\+\s*[,;=]',
        \ 'left_margin': 0, 'right_margin': 0
        \ }
      '';
    }

    {
      type = "lua";
      plugin = lualine-nvim;
      config = ''
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
        }
      '';
    }

    {
      plugin = supertab;
      config = ''
        "let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

        if has("gui_running")
          imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
        else " no gui
          if has("unix")
            inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
          endif
        endif
      '';
    }
    {
      plugin = vim-better-whitespace;
      config = ''
        let g:better_whitespace_enabled=1
        let g:strip_whitespace_on_save=1
      '';
    }
  ];

  programs.neovim.extraConfig = ''

    autocmd FileType markdown setlocal conceallevel=0

    " TODO: Alternative key mappings, which one do I want
    "nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.buf.declaration()<CR>
    "nnoremap <silent> <leader>lh    <cmd>lua vim.lsp.buf.hover()<CR>
    "nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    "nnoremap <silent> <leader>lk    <cmd>lua vim.lsp.buf.signature_help()<CR>
    "nnoremap <silent> <leader>lr    <cmd>lua vim.lsp.buf.references()<CR>
  '';

}


