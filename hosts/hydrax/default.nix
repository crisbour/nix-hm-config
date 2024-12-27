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

  time.timeZone = "Europe/Bucharest";

  boot.loader.grub = {
    enable = true;
    version = 2;
    forceInstall = true;
    device = "/dev/nvme0n1p1";
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGySvc1K+NCd+b/az6ZhtscwM3XO0hnLnB/CWavpow5T"
  ];

  users.users.cristi.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGySvc1K+NCd+b/az6ZhtscwM3XO0hnLnB/CWavpow5T"
  ];

  # TODO: Add HM inline to configure user

  system.stateVersion = "24.05";
}
