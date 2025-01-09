{ pkgs, ... }:
{
  imports = [
    ./slack.nix
  ];

  home.packages = with pkgs; [
    zoom-us
    webcord-vencord
    teams-for-linux
  ];
}

