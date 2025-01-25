{
  disko.devices = {
    # TODO: If using imperanence
    #nodev."/" = {
    #  fsType = "tmpfs";
    #  mountOptions = [ "defaults" "size=2G" "mode=755" ];
    #};
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "700M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          crypt-root = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypt-root";
              settings = {
                allowDiscards = true;
                bypassWorkqueues = true;
              };
              content = {
                type = "btrfs";
                subvolumes = let
                  # NOTE: x-gvfs-hide is useful to hiding the route of such mouting points in GUI
                  mountOptions = ["compress=zstd" "noatime" "nodiratime" ];
                in {
                  # TODO: The root can go away if we opt for impermanence
                  "/root" = {
                    mountpoint = "/";
                    inherit mountOptions;
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    inherit mountOptions;
                  };
                  "/var-log" = {
                    mountpoint = "/var/log";
                    inherit mountOptions;
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    inherit mountOptions;
                  };
                  # NOTE: Home will be part of persist
                  "/home" = {
                    mountpoint = "/home";
                    inherit mountOptions;
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    mountOptions = [ "noatime" ];
                    swap.swapfile.size = "32G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };


  #fileSystems."/persist".neededForBoot = true;
  #fileSystems."/var/log".neededForBoot = true;
}
