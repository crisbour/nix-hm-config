{ inputs, config, lib, pkgs, ... }:
{

  home.packages = [
    pkgs.unstable.mathematica
  ];

}

