{ config, ... }:
{
  sops.secrets = {
    "syncthing/password" = {
      sopsFile = ../../../secrets/secrets.yaml;
    };
  };
  # TODO: Better configure syncthing with introducer Nexus: https://github.com/ncfavier/config/blob/463d728a993721ab35d2061515a0c236580ba802/modules/syncthing.nix
  services = {
    syncthing = {
      enable = true;
      group = "users";
      user = "cristi";
      dataDir = "/home/cristi/Documents";    # Default folder for new synced folders
      #configDir = "/home/cristi/Documents/.config/syncthing";   # Folder for Syncthing settings and keys
      # If it still doens't work, try this approach to prevent syncing configs:
      # https://github.com/firecat53/nixos/blob/c0821e1597a7174cc5a862bf58e336793c47c4ad/hosts/office/services/syncthing.nix
      configDir = "/home/cristi/.config/syncthing";

      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI

       # Open necessary ports for Syncthing
      openDefaultPorts = true;

      settings.gui = {
        user = "cristi";
        passwordFile = config.sops.secrets."syncthing/password".path;
      };

      # Declarative device and folder configuration
      settings = {
        devices = {
          #"precision" = { id = "6MVZSPE-CSNORHG-XDAWLF5-CVN7M73-DIPHFPI-YPLPODB-GA6ARCJ-3L5OTAM"; };
          "w9098" = { id = "2YGQ4VQ-OOLR5FG-FRQN3FW-MAILNH7-UGXGLGS-ITBAFST-H35IEE5-2ZXXOA4"; };
        };

        folders = {
          "Documents" = {
            path = "/home/cristi/Documents";
            devices = [ "w9098" ];
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
