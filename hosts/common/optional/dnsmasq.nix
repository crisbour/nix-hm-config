{ config, pkgs, ... }:
{
  networking = {
    # Disable DHCP on the interface if it's enabled
    interfaces.enp0s20f0u2u1u1.useDHCP = false;

    # Set a static IP for the interface
    interfaces.enp0s20f0u2u1u1.ipv4.addresses = [{
      address = "192.168.44.1";
      prefixLength = 24;
    }];
  };

  # Ports necessary for DHCP
  networking.firewall = {
    allowedUDPPorts = [67 68];
  };

  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;

    # Configure dnsmasq for DHCP
    settings = {
      interface = "enp0s20f0u2u1u1";
      dhcp-range = "192.168.44.100,192.168.44.150,12h";
      dhcp-option = [
        "3,192.168.44.1" # Default gateway
        "6,8.8.8.8"      # DNS server
      ];
    };
  };
}
