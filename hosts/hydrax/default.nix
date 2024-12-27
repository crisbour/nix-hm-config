{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../common/global
    ../common/users/cristi.nix
    ../common/optional/fonts.nix
    # FIXME: YubiKey passthrough on SSH???
    #../common/optional/yubikey.nix
    ../common/optional/docker.nix
    ../common/optional/lxd.nix
  ];

  # TODO: Add HM inline to configure user

  system.stateVersion = "24.05";
}
