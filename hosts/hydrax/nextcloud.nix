{ pkgs, config, ... }:
{
  environment.etc."nextcloud-admin-pass".text = "Choo1phu";
  # For arguments reference see: https://github.com/NixOS/nixpkgs/blob/21de70db4f4eeda365303200ce2e880a42e88952/nixos/modules/services/web-apps/nextcloud.nix#L233
  services = {
    nextcloud = {
      enable = true;
      hostName = "nc.adventure-bytes.com";
      # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud30;
      # Let NixOS install and configure the database automatically.
      #database.createLocally = true;
      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;
      # Increase the maximum file upload size.
      maxUploadSize = "16G";
      https = true;
      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts notes onlyoffice tasks cookbook qownnotesapi;
        # Custom app example.
      #socialsharing_telegram = pkgs.fetchNextcloudApp rec {
      #   url =
      #     "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.0.1/socialsharing_telegram-v3.0.1.tar.gz";
      #   license = "agpl3";
      #   sha256 = "sha256-8XyOslMmzxmX2QsVzYzIJKNw6rVWJ7uDhU1jaKJ0Q8k=";
      # };
      };
      settings = {
        trusted_domains = [
          "nc.adventure-bytes.com"
          "adventure-bytes.com"
        ];
        trusted_proxies = [ "127.0.0.1" ];
        overwriteProtocol = "https";
        default_phone_region = "UK";
      };
      config = {
        dbtype = "mysql";
        #dbtype = "pgsql";
        #dbuser = "nextcloud";
        #dbname = "nextcloud";
        #dbPassFile = "${pkgs.writeText "adminpas" "test1234#43?"}";
        adminuser = "admin";
        adminpassFile = "${pkgs.writeText "adminpas" "test1234#43?"}";
      };
      # Suggested by Nextcloud's health check.
      phpOptions."opcache.interned_strings_buffer" = "16";
    };
    # Nightly database backups.
    #postgresqlBackup = {
    # enable = true;
    # startAt = "*-*-* 01:15:00";
    #};
    # https://github.com/firecat53/nixos/blob/e0b04757e8f3e591359234215214ff5554af997a/hosts/homeserver/services/nextcloud.nix#L25
    nginx.virtualHosts."localhost".listen = [ { addr = "127.0.0.1"; port = 8180; } ];
  };
  # TODO Migrate to nginx as I have troubles working with traefik: https://carlosvaz.com/posts/the-holy-grail-nextcloud-setup-made-easy-by-nixos/
}
