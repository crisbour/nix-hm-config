{ config, pkgs, ... }:
let
  domain = "adventure-bytes.com";
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    8443
    8080
  ];

  # TODO: Find more similar setup + Tailscale at: https://github.com/iggut/nixos-config/blob/8dfc1038be8fa5d8cb044b79fd5853b888d43c28/host/common/services/traefik/thor.nix#L24

  services.nginx.defaultHTTPListenPort = 8080;

  security.acme = {
    acceptTerms = true;
    defaults.email = "bourceanu_cristi@yahoo.com";
    certs."adventure-bytes.com" = {
      domain = "adventure-bytes.com";
      extraDomainNames = [ "*.adventure-bytes.com" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = "/data/secrets/cloudflare/api_key_credentials.txt";
    };
  };

  users.users.traefik.extraGroups = [ "acme" ];

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
          http.tls.domains = {
            main = domain;
            sans = [ "*.${domain}" ];
          };
        };
      };

      log = {
        level = "DEBUG";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      #certificatesResolvers.letsencrypt.acme = {
      #  # TODO: Setup email service for this domain to keep my personal email clean
      #  email = "bourceanu_cristi@yahoo.com";
      #  #storage = "${config.services.traefik.dataDir}/acme.json";
      #  storage = "/var/lib/traefik/cert.json";
      #  #caServer = "https://acme-v02.api.letsencrypt.org/directory";
      #  dnsChallenge = {
      #    provider = "cloudflare";
      #    #resolvers = [ "1.1.1.1:53" "1.0.0.1:53" ];
      #    delayBeforeCheck = 0;
      #  };
      #  #httpChallenge.entryPoint = "web";
      #};

      api.dashboard = true;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      # api.insecure = true;
    };

    dynamicConfigOptions = {
      tls = {
        stores.default = {
          defaultCertificate = {
            certFile = "/var/lib/acme/adventure-bytes.com/cert.pem";
            keyFile = "/var/lib/acme/adventure-bytes.com/key.pem";
          };
        };
        certificates = [
          {
            certFile = "/var/lib/acme/adventure-bytes.com/cert.pem";
            keyFile = "/var/lib/acme/adventure-bytes.com/key.pem";
            stores = "default";
          }
        ];
      };
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

          lxd = {
            entryPoints = [ "websecure" ];
            rule = "Host(`lxd.${domain}`)";
            tls = true;
            service = "lxd";
          };

          taskchampion = {
            entryPoints = [ "websecure" ];
            rule = "Host(`task.${domain}`)";
            service = "taskchampion";
          };

          nextcloud = {
            entryPoints = [ "web" "websecure" ];
            rule = "Host(`nc.${domain}`)";
            service = "nextcloud";
          };
        };
        services = {
          website.loadBalancer.servers = [ { url = "http://localhost:80"; } ];
          mikrotik.loadBalancer.servers = [ { url = "http://192.168.88.1:80"; } ];
          # FIXME:
          lxd.loadBalancer.servers = [ { url = "https://localhost:8443"; } ];
          taskchampion.loadBalancer.servers =
            [ {
              url = "http://localhost:${builtins.toString config.services.taskchampion-sync-server.port}";
            }];
          nextcloud.loadBalancer.servers = [
            { url = "http://127.0.0.1:8180"; }
          ];
        };
        # https://github.com/firecat53/nixos/blob/e0b04757e8f3e591359234215214ff5554af997a/hosts/vps/services/traefik.nix#L75
        middlewares = {
          headers = {
            headers = {
              browserxssfilter = true;
              contenttypenosniff = true;
              customframeoptionsvalue = "SAMEORIGIN";
              forcestsheader = true;
              framedeny = true;
              sslhost = "adventure-bytes.com";
              sslredirect = true;
              stsincludesubdomains = true;
              stspreload = true;
              stsseconds = "315360000";
            };
          };
        };
      };
    };
  };

  # TODO: Use porkbun api key from sops;
  # How to enc/dec without gpg?
  # If I use deploy-rs that will work, however, sometimes I need to test directly on the server
  systemd.services.traefik = {
    environment = {
      CF_API_EMAIL = "bourceanu_cristi@yahoo.com";
    };
    serviceConfig = {
      EnvironmentFile = [
        "/data/secrets/porkbun/acme-credentials"
        "/data/secrets/cloudflare/api_key"
      ];
    };
  };
}
