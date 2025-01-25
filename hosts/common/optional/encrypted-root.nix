{config, ...}: let
  hostname = config.networking.hostName;
in {
  boot.initrd = {
    luks.devices."${hostname}" = {
      device = "/dev/disk/by-label/${hostname}_crypt";
      allowDiscards = true;
      bypassWorkqueues = true;
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
  };
}

