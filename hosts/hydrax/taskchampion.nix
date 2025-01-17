{ pkgs, config, ... }:
{
  services.taskchampion-sync-server = {
    enable = true;
    dataDir = "/data/taskchampion-sync-server";
    port = 8001;
  };

  services.taskserver = {
    enable = true;
    dataDir = "/data/taskserver";
    ipLog = true;
    listenHost = "::";
    #listenPort = 8002;
    fqdn = "task2.adventure-bytes.com";
    organisations.nexus.users = [ "cristi" ];
  };

  networking.firewall.allowedTCPPorts = [ 53589 ];
}
