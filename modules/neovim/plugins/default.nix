{ pkgs, ... }:
{
  imports = [
    ./barbar.nix
    # Custom plugins
    ## Spade-lang syntax higlight
    ./spade-lang.nix
    ./codal

    # Local Environment Configuration and Integration
    ./vim-autoswap.nix
    ## Use different indentation per project with vim-localvimrc
    ## vim-rooter: https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/


    # Editor
    ./nvim-neoclip.nix

    # Language Server, Completion, and Formatting
    ## Format code: ./conform.nvim.nix
    ./conform.nvim.nix
    ./nvim-cmp.nix
    ./nvim-lspconfig.nix
    ./trouble.nvim.nix

    # Synatx Highlighting
    ./rainbow-delimiters.nix
    ./tree-sitter.nix

  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # Local Environment Configuration and Integration
    direnv-vim

    # Editor
    vim-closetag
    vim-surround
    vim-visual-multi

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

    fzfWrapper
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


