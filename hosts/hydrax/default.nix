{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/cristi.nix
    ../common/optional/fonts.nix
    # FIXME: YubiKey passthrough on SSH???
    #../common/optional/yubikey.nix
    ../common/optional/docker.nix
    ../common/optional/lxd.nix
  ];

  # FIXME: Deassert automatic timezone
  #time.timeZone = "Europe/Bucharest";

  networking.firewall.allowedTCPPorts = [ 80 443 ]; # Allow traffic on port 80 and hhtps on 443
  services.httpd.enable = true; # Enable the HTTP server

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGySvc1K+NCd+b/az6ZhtscwM3XO0hnLnB/CWavpow5T"
  ];

  users.users.cristi.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGySvc1K+NCd+b/az6ZhtscwM3XO0hnLnB/CWavpow5T"
  ];

  # TODO: Add HM inline to configure user
}