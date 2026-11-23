{ pkgs, config, ... }:
{
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/var/secrets/cache-private-key.pem";
    bindAddress = "w9098.hyena-royal.ts.net";
  };

  #services.nginx = {
  #  enable = true;
  #  recommendedProxySettings = true;
  #  virtualHosts.cache = {
  #    locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
  #  };
  #};

  networking.firewall.allowedTCPPorts = [
    config.services.nginx.defaultHTTPListenPort
  ];
}
