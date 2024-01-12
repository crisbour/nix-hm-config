pkgs:
let
  spade-lang = import ./spade-plugin.nix pkgs;
  codal-plugin = import ./codal/codal-plugin.nix pkgs;
in
{
  enable = true;
  viAlias = true;
  vimAlias = true;
  plugins = with pkgs.vimPlugins; [
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
    #coc-nvim
    editorconfig-vim
    {
      plugin = fzf-vim;
      config = ''
        let mapleader=' '
        " fzf bindings
        nnoremap <leader>r :Rg<CR>
        nnoremap <leader>b :Buffers<CR>
        nnoremap <leader>e :Files<CR>
        nnoremap <leader>l :Lines<CR>
        nnoremap <leader>L :BLines<CR>
        nnoremap <leader>c :Commits<CR>
        nnoremap <leader>C :BCommits<CR>
      '';
    }
    fzfWrapper
    {
      plugin = LanguageClient-neovim;
      config = ''
        nmap <silent> gd <Plug>(lcn-definition)
      '';
    }
    {
      type = "lua";
      plugin = nvim-lspconfig;
      # Inspired from https://github.com/sumnerevans/home-manager-config/blob/40d5adf9c249ffd08a0c8c8098ae43107aef68f9/modules/neovim/plugins/nvim-lspconfig.nix#L29
      config = ''
        local lspconfig = require('lspconfig')
        --local capabilities = require("cmp_nvim_lsp").default_capabilities()

        lspconfig.bashls.setup {
          cmd = { "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start" },
        }
        lspconfig.clangd.setup {
          cmd = { "${pkgs.clang-tools_17}/bin/clangd",
                  "--background-index",
                  "--suggest-missing-includes",
                  "--clang-tidy",
                  "-Wall"
                  },
        }
        lspconfig.yamlls.setup {
          cmd = { "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server", "--stdio" },
        }

        lspconfig.julials.setup{}
        lspconfig.cmake.setup{}
        lspconfig.vimls.setup{}
        lspconfig.pyright.setup{}
        lspconfig.rust_analyzer.setup{
          settings = {
            ['rust-analyzer'] = {},
          },
        }
        --require'lspconfig'.nimls.setup{}
        --require'lspconfig'.pyls.setup{}

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
            --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
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
      '';
    }
#    lightline-vim
    {
      plugin = nerdtree;
      config = ''
        set modifiable
        "CTRL-t to toggle tree view with CTRL-t
        nmap <silent> <C-t> :NERDTreeToggle<CR>
        "Set F2 to put the cursor to the nerdtree
        nmap <silent> <F2> :NERDTreeFind<CR>
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
    vim-visual-multi
#    vim-multiple-cursors
#    vim-surround
    #vimproc
    #vimproc-vim

    # themes
    gruvbox

    # Nix
    vim-nix

    # Markdown
    vim-markdown

    # Python
    semshi

    # rust
    coc-rust-analyzer

    {
      plugin = YouCompleteMe;
      config = ''
        let g:ycm_autoclose_preview_window_after_completion = 1
        let g:ycm_auto_trigger = 0
        let g:ycm_key_invoke_completion = '<Tab>'
        let g:ycm_language_server =
        \ [
        \   {
        \     'name': 'rust',
        \     'cmdline': ['rust-analyzer'],
        \     'filetypes': ['rust'],
        \     'project_root_files': ['Cargo.toml']
        \   }
        \ ]
      '';
    }
    vim-toml

    # Julia
    julia-vim

    # git
    fugitive

    # Display tabs for buffers
    {
      plugin = vim-airline;
      config = ''
        " Configure vim-ariline tabline
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'

        "  Buffer/Tabs navigation
        :map <C-K> :bnext<CR>
        :map <C-J> :bprev<CR>
      '';
    }


    # Python linter
    coc-pyright

    ## User addded
    # Spade-lang syntax higlight
    spade-lang
    {
      plugin = codal-plugin;
      config = ''
        au BufRead,BufNewFile *.codal set filetype=codal
        au BufRead,BufNewFile *.hcodal set filetype=codal

        au FileType codal set tabstop=4 shiftwidth=4 expandtab

        " Proper "ifdef" handling
        au FileType codal set syntax=codal.ifdef
      '';
    }
  ];

  extraPackages = with pkgs; [
    rust-analyzer
  ];

 # override.packages.myVimPackage = {
 #   start = [spade-lang];
 #   end = [];
 # };

  extraConfig = ''
    colorscheme gruvbox
    syntax on
    filetype plugin indent on
    set splitbelow

    set shiftwidth=2
    set tabstop=2
    set number
    set expandtab
    set foldmethod=indent
    set foldnestmax=5
    set foldlevelstart=99
    set foldcolumn=0

    " Max code size highlighted limiters
    let &colorcolumn="80,".join(range(120,999),",")
    highlight ColorColumn ctermbg=black guibg=black

    " TODO Fix manual missing plugins
    " Manual plugins
    " call plug#begin()
    "   Plug 'jceb/vim-orgmode'
    "   " vim-orgmode requires some plugins: https://github.com/jceb/vim-orgmode/blob/master/doc/orgguide.txt#L250
    "   Plug 'tpope/vim-speeddating'
    "   Plug 'kurkale6ka/vim-swap'
    " call plug#end()

    set list
    set listchars=tab:>-

    let mapleader=' '

    autocmd FileType markdown setlocal conceallevel=0

    " LanguageClient Settings
    let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ }


    " TODO: I am not writing lsp, are these still useful to me?
    nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> <leader>lh    <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    nnoremap <silent> <leader>lk    <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> <leader>lr    <cmd>lua vim.lsp.buf.references()<CR>
  '';
}

