{
  config,
  lib,
  pkgs,
  svc,
  ...
}:
let
  cfg = config.mySystem.incus;
in
# Inspired by: https://github.com/deedee-ops/nixlab/blob/f286c09139ea75ff5419e3e0b264e54b8b86f0f2/modules/system/apps/incus/default.nix
{
  options.mySystem.incus = {
    enable = lib.mkEnableOption "incus server";
    enableServer = lib.mkOption {
      type = lib.types.bool;
      description = "Enable server UI and reverse-proxy with certs";
      default = false;
    };
    serverAddr = lib.mkOption {
      type = lib.types.str;
      description = "Default core.http_address";
      default = "127.0.0.1:8443";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Path to directory containing data.";
      default = "/var/lib/incus";
    };
    defaultStoragePool = lib.mkOption {
      type = lib.types.attrs;
      description = "Default storage pool configuration for incus.";
      default = {
        config = {
          source = "${cfg.dataDir}/storage-pools/default";
          #source = "${cfg.dataDir}/disks/default.img";
          #size = "500GiB";
        };
        driver = "btrfs";
        name = "default";
      };
    };
    defaultNIC = lib.mkOption {
      type = lib.types.attrs;
      description = "Default NIC for the VM.";
      default = {
        name = "eth0";
        network = "incusbr0";
        type = "nic";
      };
      example = {
        nictype = "bridged";
        parent = "br0";
        type = "nic";
        vlan = 100;
      };
    };
    enableUI = lib.mkOption {
      type = lib.types.bool;
      description = "Enable incus UI";
      default = false;
    };
    incusUICrtSopsSecret = lib.mkOption {
      type = lib.types.str;
      description = ''
        Sops secret name containing Incus UI certificate.
        Don't use incus UI to generate it, as it generates faulty certificates, not accepted by nginx.
        Instead do:
        openssl req -newkey rsa:4096 -nodes -keyout incus-ui.key -x509 -days 36500 -out incus-ui.crt
      '';
      default = "system/apps/incus/incus-ui.crt";
    };
    incusUIKeySopsSecret = lib.mkOption {
      type = lib.types.str;
      description = ''
        Sops secret name containing Incus UI certificate.
        Don't use incus UI to generate it, as it generates faulty certificates, not accepted by nginx.
        Instead do:
        openssl req -newkey rsa:4096 -nodes -keyout incus-ui.key -x509 -days 36500 -out incus-ui.crt
      '';
      default = "system/apps/incus/incus-ui.key";
    };
    initializeBaseNixOSVM = lib.mkOption {
      type = lib.types.bool;
      description = "If set to true, it will install base image, compatible with nixos-anywhere.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    #assertions = [
    #  {
    #    assertion = (!cfg.enableUI) || config.mySystemApps.authelia.enable;
    #    message = "To use incus UI, authelia container needs to be enabled.";
    #  }
    #];

    #sops.secrets = {
    #  "${cfg.incusUICrtSopsSecret}" = {
    #    owner = "nginx";
    #    group = "nginx";
    #    restartUnits = [ "nginx.service" ];
    #  };
    #  "${cfg.incusUIKeySopsSecret}" = {
    #    owner = "nginx";
    #    group = "nginx";
    #    restartUnits = [ "nginx.service" ];
    #  };
    #};

    virtualisation.incus = {
      enable = true;
      ui.enable = cfg.enableUI;

      preseed = {
        # User profile and network for reproducible LXD containers
        networks = [
          {
            name = "${cfg.defaultNIC.network}";
            description = "Local bridge between host and LXD container for user profile";
            type = "bridge";
            config = {
              "ipv4.address" = "10.0.100.1/24";
              "ipv4.nat" = "true";
            };
          }
        ];
        storage_pools = [ (lib.recursiveUpdate cfg.defaultStoragePool { name = "default"; }) ];
        profiles = [
          {
            name = "default";
            description = "User LXD profile";
            config = {
              "security.nesting" = "true";
              "security.privileged" = "true";
              "boot.autostart" = false;
              "security.secureboot" = false;
              #"limits.cpu" = 4;
              #"limits.memory" = "8GiB";
              #"snapshots.schedule" = "@hourly";
            };
            devices = {
              root = {
                path = "/";
                pool = "default";
                #size = "200GiB";
                type = "disk";
              };
              eth0 = lib.recursiveUpdate cfg.defaultNIC { name = "eth0"; };
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
          {
            name = "docs";
            description = "Mount user Documents";
            devices = {

              docs = {
                # Allow access to home
                # TODO: Replace username "cristi" with attr value of default user from config attribute
                path="/home/cristi/Documents";
                source = "/home/cristi/Documents";
                type = "disk";
              };
            };
          }
          {
            name = "datastore";
            description = "Mount UoE datastore(s)";
            devices = {

              datastore = {
                # Allow access to home
                # TODO: Replace username "cristi" with attr value of default user from config attribute
                path="/mnt/datastore";
                source = "/mnt/datastore";
                type = "disk";
              };

              datastore_3d = {
                # Allow access to home
                # TODO: Replace username "cristi" with attr value of default user from config attribute
                path="/mnt/datastore-3D";
                source = "/mnt/datastore-3D";
                type = "disk";
              };
            };
          }
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
                type = "proxy";
                bind = "container";
                connect = "unix:@/tmp/.X11-unix/X0";
                listen = "unix:@/tmp/.X11-unix/X0";
                "security.gid" = "1000";
                "security.uid" = "1000";
              };
              X1 = {
                type = "proxy";
                bind = "container";
                connect = "unix:@/tmp/.X11-unix/X1";
                listen = "unix:@/tmp/.X11-unix/X1";
                "security.gid" = "1000";
                "security.uid" = "1000";
              };
            };
          }
        ] ++
        (lib.optional config.mySystem.info.has_nvidia {
            name = "gpu";
            description = "Nvidia GPU passthrough to container";
            devices = {
              nvidia_gpu = {
                type = "gpu";
                gputype="phsycical";
                id="nvidia.com/gpu=0";
              };
            };
          }
        );
      };
    };

    # FIXME: Replace "cristi" with atribute config.<system>.<primary_user>
    users.users.cristi = {
      extraGroups = [ "incus-admin" ];
      subUidRanges = [ { startUid = 1000000; count = 65536; } ];
      subGidRanges = [ { startGid = 1000000; count = 65536; } ];
    };

    # Incus on NixOS is unsupported using iptables
    networking.nftables.enable = true;

    networking.firewall.trustedInterfaces =
      lib.optionals (builtins.hasAttr "network" cfg.defaultNIC) [ cfg.defaultNIC.network ]
      ++ lib.optionals (builtins.hasAttr "parent" cfg.defaultNIC) [ cfg.defaultNIC.parent ];

    # Set up networking bridge for LXD
    networking.bridges = {
      ${cfg.defaultNIC.network} = {
        interfaces = [];
      };
    };
    # Bind containers ports to host. How does it behave when ports clash
    networking.nat = lib.mkIf cfg.enableServer {
      enable = true;
      internalInterfaces = ["${cfg.defaultNIC.network}"];
      # FIXME: Only used for server, but how to get main interface
      externalInterface = "tailscale0"; # Replace with your actual external interface
    };

    #environment.persistence."${config.mySystem.impermanence.persistPath}" =
    #  lib.mkIf config.mySystem.impermanence.enable
    #    { directories = [ cfg.dataDir ]; };

    #systemd.services.incus = {
    #  postStart = lib.mkAfter (
    #    (lib.optionalString cfg.enableUI ''
    #      ${lib.getExe config.virtualisation.incus.package} config set core.https_address 127.0.0.1:8443
    #      ${lib.getExe config.virtualisation.incus.package} config trust add-certificate ${
    #        config.sops.secrets."${cfg.incusUICrtSopsSecret}".path
    #      } || true
    #    '')
    #    + (lib.optionalString cfg.initializeBaseNixOSVM ''
    #      export PATH="${
    #        lib.makeBinPath [
    #          pkgs.incus
    #          pkgs.nix
    #        ]
    #      }:$PATH"
    #      if ! incus image show nixos/base/vm; then
    #        nix run github:deedee-ops/nixlab#build-base-vm
    #      fi
    #    '')
    #  );
    #};

    systemd.services.incus = lib.mkIf cfg.enableServer {
      postStart = lib.mkAfter (
        lib.optionalString cfg.enableUI ''
          ${lib.getExe config.virtualisation.incus.package} config set core.https_address ${cfg.serverAddr}
        ''
      );
    };

    # Make sure storage-pools dir exists if we choose to mount at different location than /var/lib/incus
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}/storage-pools 0755 incus incus-admin -"
    ];

    #services.nginx.virtualHosts.incus = lib.mkIf cfg.enableUI (
    #  svc.mkNginxVHost {
    #    host = "incus";
    #    proxyPass = "https://127.0.0.1:8443";
    #    extraConfig = ''
    #      proxy_ssl_certificate     ${config.sops.secrets."${cfg.incusUICrtSopsSecret}".path};
    #      proxy_ssl_certificate_key ${config.sops.secrets."${cfg.incusUIKeySopsSecret}".path};
    #    '';
    #  }
    #);

    #mySystemApps.homepage = lib.mkIf cfg.enableUI {
    #  services.Apps.Incus = svc.mkHomepage "incus" // {
    #    icon = "https://cdn.jsdelivr.net/gh/ajgon/dashboard-icons@add-incus/svg/incus.svg";
    #    container = null;
    #    description = "Virtual machines manager";
    #  };
    #};
  };
}
