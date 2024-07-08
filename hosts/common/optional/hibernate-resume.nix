{config, ...}: let
  hostname = config.networking.hostName;
in {
  #boot.resumeDevice = "/dev/mapper/${hostname}";
  boot.resumeDevice = "/dev/disk/by-uuid/2529377c-65ae-4b10-adda-c22bd9c58c66";
  boot.kernelParams = [ "resume=UUID=2529377c-65ae-4b10-adda-c22bd9c58c66" "ressume_offset=12592384" ];
  # resume offset from: `btrfs inspect-internal map-swapfile -r /swap/swapfile`
  # TODO check: https://discourse.nixos.org/t/is-it-possible-to-hibernate-with-swap-file/2852/3

  # TODO Extract this information from disko

  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=4h
    SuspendState=mem
  '';

  # Enable hibernation
  # https://wiki.archlinux.org/title/Dm-crypt/Swap_encryption#With_suspend-to-disk_support
  powerManagement.resumeCommands = ''
    cryptsetup open /dev/disk/by-label/${hostname}_crypt ${hostname}
  '';
}

