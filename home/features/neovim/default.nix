# Cool other configs to look at
# - http://www.lukesmith.xyz/conf/.vimrc
# - https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
# - https://github.com/jschomay/.vim/blob/master/vimrc
# - https://github.com/jhgarner/DotFiles

{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    #./clipboard.nix
    ./plugins
    #./shortcuts.nix
    ./theme.nix
  ];

  programs.neovim = {
    enable = true;
    extraConfig = concatMapStringsSep "\n\n" builtins.readFile [
      ./init.vim
      ./filetype-specific-configs.vim
    ];

    # TODO: Check if this is necessary
    extraPackages = with pkgs; [
      bat
      ripgrep
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withPython3 = true;
    withNodeJs = true;
    #withRuby = true;
  };

  # TODO:Add spelling suggestions
  #home.symlinks."${config.xdg.configHome}/nvim/spell/en.utf-8.add" =
  #  "${config.home.homeDirectory}/Syncthing/.config/nvim/spell/en.utf-8.add";
}
