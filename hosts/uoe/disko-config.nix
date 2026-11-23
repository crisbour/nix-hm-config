{
  disko.devices = {
    # TODO: If using imperanence
    #nodev."/" = {
    #  fsType = "tmpfs";
    #  mountOptions = [ "defaults" "size=2G" "mode=755" ];
    #};
    disk.main = {
      type = "disk";
      device = "/dev/nvme1n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks-root = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
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
                  #"/home" = {
                  #  mountpoint = "/home";
                  #  inherit mountOptions;
                  #};
                  "/swap" = {
                    mountpoint = "/swap";
                    mountOptions = [ "noatime" ];
                    swap.swapfile.size = "64G";
                  };
                };
              };
            };
          };
        };
      };
    };
    disk.data = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          luks-data = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted-data";
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
                  # NOTE: Home will be part of persist
                  "/home" = {
                    mountpoint = "/home";
                    inherit mountOptions;
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
