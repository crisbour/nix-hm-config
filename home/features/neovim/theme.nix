{ pkgs, lib, ... }:
with lib; {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
    ];

    extraConfig = ''
      " Highlight past 100 characters
      highlight Over100Length ctermbg=red ctermfg=white guibg=#BD4F4F guifg=#cccccc
      match Over100Length /\%101v.\+/
    '';
  };
}

