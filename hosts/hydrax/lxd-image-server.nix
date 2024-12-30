{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "bourceanu_cristi@yahoo.com";
    certs."adventure-bytes.com" = {
      reloadServices = [ "static-web-server" ];
      listenHTTP = ":80";
      group = "www-data";
      # EC is not supported by SWS versions before 2.16.1
      keyType = "rsa4096";
    };
  };
  services.lxd-image-server = {
    enable = true;
    group = "www-data";
    settings = builtins.fromTOML ''
      [mirrors]
        [lidar]
        user = "cristi"
        remote = "lxd.adventure-bytes.com"
        key_path = "/etc/lxd-image-server/lxdhub.key"

      [logging]
        version = 1
        disable_existing_loggers = 1

      [logging.formatters.simple]
        format = "%(message)s"

      [logging.formatters.complex]
        format = "%(levelname)s %(asctime)s %(message)s"

      [logging.handlers.filelog]
        level = "INFO"
        class = "logging.FileHandler"
        filename = "/var/log/lxd-image-server/lxd-image-server.log"
        formatter = "complex"

      [logging.handlers.console]
        level = "ERROR"
        class = "logging.StreamHandler"
        formatter = "simple"

      # Main logger of the application
      [logging.loggers.lxd_image_server]
        handlers = ["console", "filelog"]
        level = "INFO"
        propagate = false
    '';
    nginx = {
      enable = true;
      domain = "lxd.adventure-bytes.com";
    };
  };
}
