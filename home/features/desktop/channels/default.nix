{ pkgs, ... }:
{
  imports = [
    ./slack.nix
  ];

  home.packages = with pkgs; [
    discord
    teams-for-linux
  ];
}

