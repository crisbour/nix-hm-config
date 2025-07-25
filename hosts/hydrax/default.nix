{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/cristi.nix
    ../common/optional/fonts.nix
    # FIXME: YubiKey passthrough on SSH???
    #../common/optional/yubikey.nix
    ../common/optional/docker.nix
    #./server.nix
    ./reverse-proxy.nix
    #./lxd-image-server.nix
    ./xserver.nix
    ./taskchampion.nix
    ./nextcloud.nix
  ];

  # FIXME: Deassert automatic timezone
  #time.timeZone = "Europe/Bucharest";

  mySystem.info = {
    hostname = "nexus";
    has_gui = false;
    has_intel = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 ]; # Allow ssh

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  mySystem.incus = {
    enable = true;
    enableServer = true;
    serverAddr = "${config.mySystem.info.hostname}.hyena-royal.ts.net";
    enableUI = true;
    dataDir = "/data/incus";
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

  nix.settings.trusted-users = [ "root" "@wheel" ];

  networking.hostName = config.mySystem.info.hostname;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGySvc1K+NCd+b/az6ZhtscwM3XO0hnLnB/CWavpow5T"
  ];

  users.users.cristi.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGySvc1K+NCd+b/az6ZhtscwM3XO0hnLnB/CWavpow5T"
  ];

  # TODO: Add HM inline to configure user
}
