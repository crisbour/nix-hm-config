{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.services.pypi-server;
in {
  options.services.pypi-server= {
    enable = lib.mkEnableOption {
      default = false;
      description = lib.mdDoc "Whether to activate PYPI, a service to accepth private PYPI publish and download";
      example = lib.literalExpression "true";
    };
    package = lib.mkPackageOption pkgs "pypiserver" {};
    systemdEnable = lib.mkEnableOption {
      default = false;
      description = lib.mdDoc "Whether to enable the pypi systemd service";
      example = lib.literalExpression "true";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8085;
    };
    packagesDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/pypi/packages";
    };
    openFirewall = lib.mkEnableOption "Open firewall port for pypi-server";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall) [ cfg.port ];

    systemd.services.pypi-server=
       {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "Private PYPI build packages as cache to fetch my packages";
        documentation = [ "https://pypi.org/project/pypiserver/" ];
        serviceConfig = {
          ExecStart = "${pkgs.pypiserver}/bin/pypi-server run -p ${toString cfg.port} -P . -a . ${cfg.packagesDir}";
          StandardOutput = "journal";
          StandardError = "journal";
          #PrivateNetwork = true;
          PrivateMounts = false;
          Restart = "on-failure";
          #Environment = "RUST_LOG=debug";
        };
      };
  };
}
