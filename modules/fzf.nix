{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;

    # TODO: Cleanup if not useful
    #changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    #defaultCommand = "fd --type f --hidden --follow --exclude '.git'";
    #defaultOptions = [ "--border" "--height 40%" ];
    #fileWidgetOptions =
    #  [ "--preview 'bat --style=numbers --color=always --line-range :500 {}'" ];
    #colors = {
    #  fg = "-1";
    #  bg = "-1";
    #  hl = "#c678dd";
    #  "fg+" = "#ffffff";
    #  "bg+" = "#4b5263";
    #  "hl+" = "#d858fe";
    #  info = "#98c379";
    #  prompt = "#61afef";
    #  pointer = "#be5046";
    #  marker = "#e5c07b";
    #  spinner = "#61afef";
    #  header = "#61afef";
    #};

  };
}
