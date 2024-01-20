{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  yed-highdpi = writeShellScriptBin "yed" ''
    exec env GDK_SCALE=2 ${yed}/bin/yed
  '';
in
symlinkJoin {
  name = "yed";
  paths = [
    yed-highdpi
    yed
  ];
}
#stdenv.mkDerivation {
#  name = "yed";
#
#  buildInputs = [ yed ];
#
#  installPhase = ''
#    mkdir -p $out/bin
#    echo << EOF
#    #!/bin/env sh
#    GDK_SCALE=2
#    EOF ${yed}/bin/yed" > $out/bin/$yed
#
#    chmod +x $out/bin/yed
#  '';
#}
