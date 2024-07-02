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
    #initialPassword = "ChangeMe1";
    hashedPassword = "$6$yWS.QK38hcrqXli9$bo.Bq8ElKCp/C9.JZmEa3ONjawBPm0GQ1kZKrnwStcT0hUISHLfXJU1co85PbqNpMQ0nC3BY.Pb45wEpDTZPA0";
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
