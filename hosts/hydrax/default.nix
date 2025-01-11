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
    #./server.nix
    ./reverse-proxy.nix
    #./lxd-image-server.nix
  ];

  # FIXME: Deassert automatic timezone
  #time.timeZone = "Europe/Bucharest";

  environment.systemPackages = with pkgs; [
    xorg.xauth
    # other packages...
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 22 8787 ]; # Allow traffic on port 80 and hhtps on 443

  service.incus = {
    enable = true;
    enableServer = true;
    enableUI = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      X11Forwarding = true;  # Enable X11 forwarding
      X11DisplayOffset = 10;
      X11UseLocalhost = false;
      AllowTcpForwarding = true;
      UseDns = true;  # Use DNS for hostname resolution
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
