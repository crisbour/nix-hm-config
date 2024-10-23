{
  pkgs,
  config,
  lib,
  ...
}:
{
  # ------- CIFS ---------
  fileSystems."/mnt/datastore" = {
    device = "//csce.datastore.ed.ac.uk/csce/eng/users/s2703496";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,domain=ED,user=s2703496,vers=2.0,noserverino,uid=1000,gid=100"];

    # Create /etc/nixos/smb-secrets with:
    # password=your_password
  };

  # ---------- BINDFS ------------
  # Allow other used to bind mount
  programs.fuse = {
    userAllowOther = true;
  };
}
