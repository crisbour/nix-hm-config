# A basic bash configuration inspired by ubuntu defaults. I keep this light
#  as most configuration is done in zsh.
# I don't use bash much but it is a good fallback in case zsh is having issues
{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    historyControl = ["erasedups" "ignorespace"];
    shellOptions = [
        "autocd"
        "cdspell"
        "cmdhist"
        "dotglob"
        "histappend"
        "expand_aliases"
      ];
    initExtra = ''
      # set a fancy prompt (non-color, unless we know we "want" color)
      case "$TERM" in
          xterm-color|*-256color) color_prompt=yes;;
      esac

      # uncomment for a colored prompt, if the terminal has the capability; turned
      # off by default to not distract the user: the focus in a terminal window
      # should be on the output of commands, not on the prompt
      force_color_prompt=yes

      if [ -n "$force_color_prompt" ]; then
        color_prompt=yes
          else
        color_prompt=
      fi

      if [ "$color_prompt" = yes ]; then
          PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      else
          PS1='\u@\h:\w\$ '
      fi
      unset color_prompt force_color_prompt

      # If this is an xterm set the title to user@host:dir
      case "$TERM" in
      xterm*|rxvt*|screen*|tmux*)
          PS1="\[\e]0;\u@\h: \w\a\]$PS1"
          ;;
      *)
          ;;
      esac

      # colored GCC warnings and errors. this isn't needed in my experience but is
      #  nice to have
      export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

      HISTFILESIZE=10000
      HISTSIZE=10000

      shopt -s histappend
      shopt -s checkwinsize
      shopt -s extglob
      shopt -s globstar
      shopt -s checkjobs
    '';

    shellAliases = {
        #cat  = "bat";
        ll   = "ls -alF";
        la   = "ls -A";
        l    = "ls -CF";
        ls   = "ls --color=auto";
      };
  };
}

