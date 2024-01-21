# Inspired from https://github.com/lanice/nixhome/blob/c7067ad78ee9ddbae61e12ffad9f9211ad631be2/home/lanice/features/desktop/nixGL/nixGLWrapper.nix
{
  pkgs,
  targetPkg,
  name,
}:
pkgs.symlinkJoin {
  inherit name;
  paths = [
    (pkgs.writeShellScriptBin name
      ''
        ${pkgs.nixgl.nixGLDefault}/bin/nixGLDefault ${targetPkg}/bin/${name}
      '')
    targetPkg
  ];
}
