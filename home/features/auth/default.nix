{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./gpg.nix
    #./sops.nix
  ];
}
