{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {

  imports = [
    ../optional/sops.nix
  ];

  programs.zsh = {
    enable = true;
    # Disable double compinit, cause of slow zsh startup
    enableGlobalCompInit = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cristi = {
    isNormalUser = true;
    description = "Cristi Bourceanu";
    shell = pkgs.zsh;
    #initialPassword = "ChangeMe1";
    extraGroups = ifTheyExist [
      "netdev"
      "wheel"
      "docker"
      "networkmanager"
      "i2c"
      "wireshark"
      "wheel"
      "libvirtd"
      "kvm"
      "video"
      "www-data"
      "i2c"
      "pico"
    ];
    packages = with pkgs; [
      home-manager
      nixos-option
      firefox
      gcc
    ];

    #openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/gabriel/ssh.pub);
    #hashedPasswordFile = config.sops.secrets.gabriel-password.path;
  };

  #home-manager.users.cristi = import ../../../../home/cristi/${config.networking.hostName}.nix;

  # TODO define secrets here
}
