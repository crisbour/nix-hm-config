{ pkgs, ... }:
{
  #TODO: If necessary create nvim flake: https://primamateria.github.io/blog/neovim-nix/
  imports = [
    ./barbar.nix

    # Languages
    ./quarto.nix
    ## Custom plugins
    ./eldritch-trace
    #./codal
    ### Spade-lang syntax higlight
    #./spade

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
    # TODO: Learn how to make use of this plugin to inspect warnings and errors
    ./trouble.nvim.nix

    # Synatx Highlighting
    ./rainbow-delimiters.nix
    ./tree-sitter.nix
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # Basic
    plenary-nvim
    which-key-nvim
    {
      type = "lua";
      plugin = auto-session;
      config = ''
        require('auto-session').setup({})
      '';
    }

    # Markdown preview
    markdown-preview-nvim
    mkdx # TODO: Configure for my preference use cases: https://github.com/SidOfc/mkdx?tab=readme-ov-file

    # Local Environment Configuration and Integration
    direnv-vim

    # Editor
    vim-suda
    vim-closetag
    vim-surround # Add and change surroundings of words and lines. Need better hints to remember commands
    vim-visual-multi # TODO: Learn how to use it or remove it
    # NOTE: More customisation at https://githlb.com/gvolpe/neovim-flake/blob/2b374d1610bb9392c52ddecf70bb0b32555737fe/modules/todo/todo-comments.nix#L38
    {
      type = "lua";
      plugin = aerial-nvim;
      config = builtins.readFile ./config/aerial-nvim.lua;
    }
    {
      type = "lua";
      plugin = todo-comments-nvim;
      config = ''
        require('todo-comments').setup()
      '';
    }
    {
      type = "lua";
      plugin = text-case-nvim;
      config = builtins.readFile ./config/textcase.lua;
    }

    # Helpers
    ## TOOD: Avante with ELM (OpenAI compatible service from UoE) and local ollama
    {
      plugin = pkgs.vimPlugins.avante-nvim;
      type = "lua";
      config = builtins.readFile ./config/avante-nvim.lua;
    }
    ## Copilot setup as suggested by: https://tamerlan.dev/setting-up-copilot-in-neovim-with-sane-settings/
    {
      type = "lua";
      plugin = pkgs.unstable.vimPlugins.copilot-lua;
      config = ''
      '';
    }

    # ------ git -------
    vim-fugitive

    # TODO: Use format rules across text editors
    editorconfig-vim

    # ------ languages -------
    {
      plugin = vimtex;
      type = "viml";
      config = ''
        let g:vimtex_view_general_viewer = 'okular'
        let maplocalleader = ";"
        set encoding=utf-8
      '';
    }
    vim-just
    julia-vim
    vim-pluto

    {
      plugin = vim-slime;
      type = "viml";
      config = ''
        let g:slime_target = "tmux"
        let g:slime_bracketed_paste = 1
        let g:slime_paste_file = tempname()
        let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
      '';
    }

    {
      type = "lua";
      plugin = nvim-tree-lua;
      config = builtins.readFile ./config/nvim-tree-lua.lua;
    }

    {
      plugin = vim-easy-align;
      type = "viml";
      config = builtins.readFile ./config/vim-easy-align.vim;
    }

    {
      type = "lua";
      plugin = lualine-nvim;
      config = builtins.readFile ./config/lualine-nvim.lua;
    }

    {
      plugin = supertab;
      type = "viml";
      config = builtins.readFile ./config/supertab.vim;
    }
    {
      plugin = vim-better-whitespace;
      type = "viml";
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


