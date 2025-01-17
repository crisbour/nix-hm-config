{
  config,
  pkgs,
  libs,
  ...
}:
{
  home.packages = with pkgs; [
    taskwarrior2
    taskwarrior-tui
    #timewarrior # Not sure how to use it
    tasksh
  ];

  services.taskwarrior-sync = {
    enable = true;
    frequency = "hourly";
  };

  # Inspired: https://github.com/jevy/home-manager-nix-config/blob/5a088cb8f00e046c9473e39c4c390d31911f495b/taskwarrior/taskrc
  home.shellAliases = {
    # Taskwarrior
    tr = "clear && task ready";
    t = "clear && task";
    tt = "taskwarrior-tui";
    tw = "task waiting";
    tin = "task add +in";
  };

  # TODO Add bugwarrior for GitHub, GitLab integration

  # TODO Is it possible to integrate it with Joplin?

  # TODO Implement GTD setup with Inbox: https://github.com/jpcenteno/nixos-config/blob/b9b52ad4974461d6dd353b5a4730c06a83fc0f3d/modules/home-manager/taskwarrior.nix#L9

  # TODO Oraganize contexts: https://github.com/roosemberth/dotfiles/blob/1047ab1c9813d91a54a838eb387bba5934901f05/nix/modules/agenda.nix#L20

  home.file = {
    ".taskrc".source = ./taskrc;
  };


}
