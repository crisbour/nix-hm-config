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
    terminal = "xterm-256color";
    #extraConfig = lib.strings.fileContents ./tmux.conf;
    extraConfig = ''
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
      set -g mode-keys emacs
      set -g status-keys emacs

      bind Escape copy-mode

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind-key J resize-pane -D 5
      bind-key K resize-pane -U 5
      bind-key H resize-pane -L 5
      bind-key L resize-pane -R 5
    '';
  };
}
