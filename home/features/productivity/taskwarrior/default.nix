{
  config,
  pkgs,
  libs,
  ...
}:
let
  mount_directory   = "${config.home.homeDirectory}/OneDrive";
  onedrive_task_dir = "${mount_directory}/Apps/TaskWarrior";
  local_task_dir    = "${config.home.homeDirectory}/.task";
in

{
  home.packages = with pkgs; [
    taskwarrior3
    taskwarrior-tui
    #timewarrior # Not sure how to use it
    tasksh
    google-cloud-sdk
  ];

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

  # HACK: Syncronize task DB back and forth, but long term solution is
  # task-sync: https://github.com/GothenburgBitFactory/taskchampion-sync-server
  systemd.user.services = {
    rclone-sync-taskdb = {
      Unit = {
        Description = "Bidirectional sync of taskwarrior DB based on timestamps";
        AssertPathIsDirectory = onedrive_task_dir;
        Wants = "network-online.target";
        After = "network-online.target";
      };

      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone sync --update ${local_task_dir}/taskchampion.sqlite3 ${onedrive_task_dir}
          ${pkgs.rclone}/bin/rclone sync --update ${onedrive_task_dir}/taskchampion.sqlite3 ${local_task_dir}
        '';
      };
    };
  };

  systemd.user.timers = {
    rclone-sync-taskdb = {
      Unit = {
        Description = "Timer for bidirectional taskwarrior DB sync";
      };
      Timer = {
        OnBootSec = "5m";
        OnUnitActiveSec = "15m";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };

}
