{ pkgs, ... }:
{
  imports = [
    ./slack.nix
  ];

  home.packages = with pkgs; [
    zoom-us
    discord
    teams-for-linux
  ];
}

