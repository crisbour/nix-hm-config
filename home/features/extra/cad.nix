{pkgs, inputs, ...}:
{
  home.packages = [
    inputs.solidcraft.packages.${pkgs.stdenv.hostPlatform.system}.solidcraft
  ];
}
