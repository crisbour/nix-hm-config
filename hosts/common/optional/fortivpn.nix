{ config, pkgs, inputs, ... }:
{
  networking.networkmanager.enable = true;

  # Support for IPSec VPN
  networking.networkmanager.enableStrongSwan = true;

  services.xl2tpd.enable = true;
  services.strongswan.enable = true;

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-fortisslvpn
    #networkmanager-openconnect
    networkmanager-openvpn
    networkmanager-l2tp
    networkmanager_strongswan
    #networkmanager-vpnc
  ];

  environment = {
    systemPackages = with pkgs; [
      openfortivpn
    ];

    etc."openfortivpn/config".text = ''
      host=remote.net.ed.ac.uk
      port=8443
      username=s2703496
      set-dns=0
      set-routes=0
    '';
  };
}
