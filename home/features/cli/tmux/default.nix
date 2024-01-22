{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    screen
  ];
  programs.tmux = {
    enable = true;
    shortcut = "b";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    terminal = "tmux-256color";
    extraConfig = lib.strings.fileContents ./tmux.conf;
  };
}
