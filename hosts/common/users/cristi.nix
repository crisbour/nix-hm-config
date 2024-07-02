{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cristi = {
    isNormalUser = true;
    description = "Cristi Bourceanu";
    extraGroups = ifTheyExist [
      "docker"
      "wheel"
      "networkmanager"
      "i2c"
      "wireshark"
      "wheel"
      "lxd"
      "libvirtd"
    ];
    packages = with pkgs; [
      nixos-option
      brave
      firefox
      gcc
    ];
  };

    openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/gabriel/ssh.pub);
    hashedPasswordFile = config.sops.secrets.gabriel-password.path;
    packages = [pkgs.home-manager];
  };

  sops.secrets.gabriel-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.gabriel = import ../../../../home/gabriel/${config.networking.hostName}.nix;

