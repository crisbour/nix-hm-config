{ config, pkgs, inputs, ... }:
{
  networking.networkmanager.enable = true;

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-fortisslvpn
    networkmanager-openconnect
    networkmanager-openvpn
    #networkmanager-l2tp
    #networkmanager-vpnc
  ];

  environment = {
    systemPackages = with pkgs; [
      openfortivpn
    ];

    etc."openfortivpn/config".text = ''
      host = "remote.net.ed.ac.uk";
      port = 8443;
      username = "s2703496";
      password = "dHf9|)"R%01S>^3Q";
    '';
  };
}
