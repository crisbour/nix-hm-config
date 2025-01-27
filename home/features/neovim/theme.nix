{ pkgs, lib, ... }:
with lib; {

  # TODO: I don't quite like the style on nvim imposed by stylix
  # revert to use manually configured theme
  stylix.targets = {
    nixvim.enable = false;
    neovim.enable = false;
  };

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      #nightfox-nvim
      gruvbox
    ];

    extraConfig = ''
    if ($TERM == 'alacritty' || $TERM == 'tmux-256color' ||
      \ $TERM == 'xterm-256color' || $TERM == 'screen-256color') && !has('gui_running')
          set termguicolors
      endif

      colorscheme gruvbox
      set background=dark

      " Highlight past 100 characters
      highlight Over100Length ctermbg=red ctermfg=white guibg=#BD4F4F guifg=#cccccc
      match Over100Length /\%101v.\+/
    '';
  };
}

