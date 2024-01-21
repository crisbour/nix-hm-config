{ config, lib, pkgs, ... }:
{
  programs.zellij = {
    enable = true;
  };


  # TODO Move programs and config in a single place
  home.file.zellij = {
    target = ".config/zellij/config.kdl";
    source = ./config.kdl;
  };
}
