{
  pkgs,
  config,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # NFS for UoE
    samba
    cifs-utils
  ];

  # ------- CIFS ---------
  fileSystems."/mnt/datastore" = {
    device = "//csce.datastore.ed.ac.uk/csce/eng/users/s2703496";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=10s,x-systemd.mount-timeout=10s";
    in ["${automount_opts},credentials=${config.sops.templates."uoe-cifs-credentials".path},vers=2.0,noserverino,uid=1000,gid=100"];

    # Create /etc/nixos/smb-secrets with:
    # password=your_password
  };

  fileSystems."/mnt/datastore-3D" = {
    device = "//csce.datastore.ed.ac.uk/csce/eng/groups/3D_VISION";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=${config.sops.templates."uoe-cifs-credentials".path},vers=2.0,noserverino,uid=1000,gid=100"];

    # Create /etc/nixos/smb-secrets with:
    # password=your_password
  };

  # ---------- BINDFS ------------
  # Allow other used to bind mount
  programs.fuse = {
    userAllowOther = true;
  };

  # ------------ SOPS -------------
  sops.templates."uoe-cifs-credentials" = {
    owner = "cristi";
    content = ''
      username=${config.sops.placeholder."uoe_cifs/username"}
      password=${config.sops.placeholder."uoe_cifs/password"}
      domain=${config.sops.placeholder."uoe_cifs/domain"}
    '';
  };
  sops.secrets."uoe_cifs/username" = {};
  sops.secrets."uoe_cifs/password" = {};
  sops.secrets."uoe_cifs/domain" = {};

}
