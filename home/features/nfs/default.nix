{ pkgs, config, ... }:
let
  mount_directory = "${config.home.homeDirectory}/OneDrive";
in
{
  home.packages = with pkgs; [
    fuse
    rclone
  ];

  # Setup sync between Documents and onedrive:Documents as in https://codingnotions.com/fully-automated-backup-rclone/

  systemd.user.services = {
    rclone-onedrive= {
      Unit = {
        Description = "Automount Microsoft OneDrive folder using rclone";
        AssertPathIsDirectory = mount_directory;
        Wants = "network-online.target";
        After = "network-online.target";
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full onedrive: ${mount_directory}";
        ExecStop = "${pkgs.fuse}/bin/fusermount -zu ${mount_directory}";
        Restart = "on-failure";
        RestartSec = 30;
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
