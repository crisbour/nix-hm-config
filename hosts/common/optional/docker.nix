{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
  };

  users.users.cristi.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    docker
  ];
}
