# TODO: Understand why Misterio77 cleans up the btrfs subvolumes at each boot?
{
  lib,
  config,
  ...
}: let
  hostname = config.networking.hostName;
in {
  boot.initrd = {
    supportedFilesystems = ["btrfs"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "noatime"
        "compress=zstd"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "noatime"
        "compress=zstd"
      ];
    };

    "/home" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "noatime"
        "compress=zstd"
      ];
    };

    "/persist" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [
        "subvol=persist"
        "noatime"
        "compress=zstd"
      ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/mapper/${hostname}";
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "noatime"
      ];
    };
  };
}

