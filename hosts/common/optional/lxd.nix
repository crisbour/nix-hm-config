{pkgs, lib, ...}:
{

  systemd.services.lxd.path = with pkgs; [
    qemu_kvm
  ];

  # ==================================================================================
  # User defined
  # ==================================================================================

  users.users.cristi = {
    extraGroups = ["lxd"];
    subUidRanges = [ { startUid = 1000000; count = 65536; } ];
    subGidRanges = [ { startGid = 1000000; count = 65536; } ];
  };

  # Adding lxd and overriding the package
  virtualisation = {
    lxd = {
      enable=true;
      ui.enable = true;

      # using the package of our overlay
      # package = pkgs.lxd-vmx.lxd.override {useQemu = true;};
      recommendedSysctlSettings=true;

      preseed = {
        # User profile and network for reproducible LXD containers
        networks = [
          {
            name = "lxdbr0";
            description = "Local bridge between host and LXD container for user profile";
            type = "bridge";
            config = {
              "ipv4.address" = "10.0.100.1/24";
              "ipv4.nat" = "true";
            };
          }
        ];
        storage_pools = [
          {
            name = "default";
            driver = "btrfs";
            config = {
              source = "/var/lib/lxd/storage-pools/default";
            };
          }
        ];
        profiles = [
          {
            name = "default";
            description = "User LXD profile";
            config = {
              "security.nesting" = "true";
              "security.privileged" = "true";
            };
            devices = {
              eth0 = {
                name = "eth0";
                network = "lxdbr0"; # Use your defined bridge
                type = "nic";
              };
            };
          }
          {
            name = "nix";
            description = "Nix Store mount";
            devices = {
              nix-store = {
                path = "/nix/store";
                source = "/nix/store";
                readonly = true;
                type = "disk";
              };
            };
          }
          {
            name = "home";
            description = "Mount user home";
            devices = {
              home = {
                # Allow access to home
                # TODO: Replace username "cristi" with attr value of default user from config attribute
                path="/home/cristi";
                source = "/home/cristi";
                type = "disk";
              };
            };
          }
          #{
          #  name = "gpu";
          #  description = "GPU passthrough to container";
          #  devices = {
          #    gpu = {
          #      type = "gpu";
          #    };
          #  };
          #}
          {
            name = "x11";
            description = "Xorg(X11) forward";
            config = {
              "environment.DISPLAY" = ":1";
              "environment.WAYLAND_DISPLAY" = "wayland-1";
            };
            devices = {
              waylandSocket = {
                type = "proxy";
                bind = "container";
                connect = "unix:/run/user/1000/wayland-1";
                listen = "unix:/mnt/wayland-1";
                "security.gid" = "1000";
                "security.uid" = "1000";
                # Following available only for non abstract proxy device
                #gid = "1000";
                #uid = "1000";
                #mode = "0700";
              };
              X0 = {
                bind = "container";
                connect = "unix:@/tmp/.X11-unix/X0";
                listen = "unix:@/tmp/.X11-unix/X0";
                "security.gid" = "1000";
                "security.uid" = "1000";
                type = "proxy";
              };
              X1 = {
                bind = "container";
                connect = "unix:@/tmp/.X11-unix/X1";
                listen = "unix:@/tmp/.X11-unix/X1";
                "security.gid" = "1000";
                "security.uid" = "1000";
                type = "proxy";
              };
            };
          }
        ];
      };
    };

    lxc = {
      enable = true;
      lxcfs.enable = true;

      # This enables lxcfs, which is a FUSE fs that sets up some things so that
      # things like /proc and cgroups work better in lxd containers.
      # See https://linuxcontainers.org/lxcfs/introduction/ for more info.
      #
      # Also note that the lxcfs NixOS option says that in order to make use of
      # lxcfs in the container, you need to include the following NixOS setting
      # in the NixOS container guest configuration:
      #
      defaultConfig = "lxc.include = ''${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf";

      systemConfig = ''
        lxc.lxcpath = /var/lib/lxd/storage-pools # The location in which all containers are stored.
      '';
    };

    libvirtd = {
      enable = true;
      qemu.runAsRoot = true;
    };
  };


  # Set up networking bridge for LXD
  networking = {
    bridges = {
      lxdbr0 = {
        interfaces = [];
      };
    };
    nat = {
      enable = true;
      internalInterfaces = ["lxdbr0"];
      externalInterface = "eth0"; # Replace with your actual external interface
    };
  };
  networking.firewall.trustedInterfaces = [ "lxdbr0" ];
}
