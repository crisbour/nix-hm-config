{ pkgs, config, ... }:
{
  services.taskchampion-sync-server = {
    enable = true;
    dataDir = "/data/taskchampion-sync-server";
    port = 8001;
  };

  #services.traefik.dynamicConfigOptions = {
  #  http = {
  #    taskchampion = {
  #      entryPoints = [ "web" "websecure" ];
  #      # TODO: Extract domain from config.server.domain
  #      rule = "Host(`task.adventure-bytes.com`)";
  #      tls = true;
  #      service = "taskchampion";
  #    };
  #  };
  #  services =
  #  {
  #    taskchampion.loadBalancer.servers = let port = config.services.taskchampion-sync-server.port; in
  #      [ { url = "http://127.0.0.1:${builtins.toString port}"; } ];
  #  };
  #};

}
