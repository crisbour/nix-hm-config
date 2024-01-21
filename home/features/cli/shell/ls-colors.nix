{ pkgs ? import <nixpkgs> {} }:
pkgs.runCommand "ls-colors" {} ''
  mkdir -p $out/bin
  ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
  ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors
''
