{ config, ... }:
{
  sops.secrets = {
    "syncthing/password" = {
      sopsFile = ../../../secrets/secrets.yaml;
    };
  };
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

      guiAddress = "w9098.hyena-royal.ts.net:8384";
      settings.gui = {
        user = "cristi";
        passwordFile = config.sops.secrets."syncthing/password".path;
        insecureSkipHostcheck = true;
      };

      # Declarative device and folder configuration
      settings = {
        devices = {
          "precision" = { id = "G7TYXCQ-7QGHWJU-NPFCBYN-K47EDJL-3BSAPOW-TD4ZMNP-C6LP5NQ-GHRAWAO"; };
          #"w9098" = { id = "ZXJRZV4-ZLEGFRF-4DHGLFV-DYIBCFJ-K7JEYDQ-KBHZFKI-M4PYZ65-7LJVIQX"; };
        };

        folders = {
          "Documents" = {
            path = "/home/cristi/Documents";
            devices = [ "precision" ];
          };
        };

      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
