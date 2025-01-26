{
  # TODO: Better configure syncthing with introducer Nexus: https://github.com/ncfavier/config/blob/463d728a993721ab35d2061515a0c236580ba802/modules/syncthing.nix
  services = {
    syncthing = {
      enable = true;
      group = "users";
      user = "cristi";
      dataDir = "/home/cristi/Documents";    # Default folder for new synced folders
      configDir = "/home/cristi/Documents/.config/syncthing";   # Folder for Syncthing settings and keys
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI

       # Open necessary ports for Syncthing
      openDefaultPorts = true;

      # WARN: Secure the web interface
      #settings.gui = {
      #  user = "cristi";
      #  password = "your-secure-password";
      #};

      # Declarative device and folder configuration
      settings = {
        devices = {
          #"precision" = { id = "6MVZSPE-CSNORHG-XDAWLF5-CVN7M73-DIPHFPI-YPLPODB-GA6ARCJ-3L5OTAM"; };
          "w9098" = { id = "BP5637K-MJV447D-FUWQHH7-XTYU7F4-76W72ZL-OVQAZSA-LFLPDUW-NIALZQQ"; };
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
