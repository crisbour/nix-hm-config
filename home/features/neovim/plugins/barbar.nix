{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-web-devicons
    {
      plugin = barbar-nvim;
      config = ''
        " Re-order to previous/next
        nnoremap <silent> <A-<> <Cmd>BufferMovePrevious<CR>
        nnoremap <silent> <A->> <Cmd>BufferMoveNext<CR>

        " Close buffer
        nnoremap <silent> <A-x> <Cmd>BufferClose<CR>

        " Buffer navigation
        map <C-j> <Cmd>BufferPrevious<CR>
        map <C-k> <Cmd>BufferNext<CR>
      '';
    }
  ];
}
