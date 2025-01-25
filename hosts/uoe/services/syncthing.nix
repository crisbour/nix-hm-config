{
  services = {
    syncthing = {
      enable = true;
      group = "users";
      user = "cristi";
      dataDir = "/home/cristi/Documents";    # Default folder for new synced folders
      configDir = "/home/cristi/Documents/.config/syncthing";   # Folder for Syncthing settings and keys

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
          "precision" = { id = "ZXJRZV4-ZLEGFRF-4DHGLFV-DYIBCFJ-K7JEYDQ-KBHZFKI-M4PYZ65-7LJVIQX"; };
          #"w9098" = { id = "ZXJRZV4-ZLEGFRF-4DHGLFV-DYIBCFJ-K7JEYDQ-KBHZFKI-M4PYZ65-7LJVIQX"; };
        };

        folders = {
          "Documents" = {
            path = "/home/cristi/Documents";
            devices = [ "precision" ];
          };
        };

        gui = {
          insecureSkipHostcheck = true;
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
