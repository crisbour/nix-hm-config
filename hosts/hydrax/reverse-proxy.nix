{ config, pkgs, ... }:
let
  domain = "adventure-bytes.com";
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    8080
  ];

  # TODO: Find more similar setup + Tailscale at: https://github.com/iggut/nixos-config/blob/8dfc1038be8fa5d8cb044b79fd5853b888d43c28/host/common/services/traefik/thor.nix#L24

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
          forwardedHeaders = {
            trustedIPs = [
              "127.0.0.1/32"
              "10.0.0.0/8"
              "192.168.0.0/16"
            ];
          };
        };

        websecure = {
          address = ":443";
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = {
        # TODO: Setup email service for this domain to keep my personal email clean
        email = "bourceanu_cristi@yahoo.com";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };

      api.dashboard = true;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      # api.insecure = true;
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          default-router = {
            entryPoints = [ "web" "websecure"];
            rule = "Host(`${domain}`)";
            service = "website";
          };

          mikrotik-router = {
            entryPoints = [ "web" "websecure" ];
            rule = "Host(`mikrotik.${domain}`)";
            service = "mikrotik";
          };
        };
        services = {
          website.loadBalancer.servers = [ { url = "http://localhost:80"; } ];

          mikrotik.loadBalancer.servers = [ { url = "http://192.168.88.1:80"; } ];
        };
      };
    };
  };
}
