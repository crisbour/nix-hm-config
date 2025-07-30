{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.lanzaboote.nixosModules.lanzaboote

    ./hardware-configuration.nix

    ../common/global
    ../common/optional/desktop.nix
    ../common/optional/hyprland.nix
    ../common/users/cristi.nix
    ../common/optional/fonts.nix
    ../common/optional/yubikey.nix
    ../common/optional/udev.nix
    ../common/optional/docker.nix
    ../common/optional/gitlab-runner.nix
    # WARN: Cannot use nvidia driver and vfio concurently
    ../common/optional/kvm.nix
    # UoE VPN and CIFS
    #../common/optional/fortivpn.nix
    ../common/optional/uoe-cifs.nix
    ../common/optional/ed-printer.nix
    ./services
    ./sops.nix
  ];

  mySystem.info = {
    hostname = "w9098";
    has_gui = true;
    has_intel = true;
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraSetFlags = ["--advertise-exit-node"];
  };
  # Optional: loosen reverse path filtering to avoid connectivity issues
  networking.firewall.checkReversePath = "loose";

  mySystem.incus = {
    enable = true;
    # Needed to let remote local: push to another remote
    enableServer = true;
    serverAddr = "${config.mySystem.info.hostname}.hyena-royal.ts.net";
    defaultNIC = {
      name = "eno1";
      network = "incusbr0";
      type = "nic";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 8443 ];

  # TODO: Move to virtualisation module docker/kvm
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  networking.bridges = {
    "virbr0" = {
      interfaces = [ ];
    };
  };
  networking.interfaces.virbr0 = {
    useDHCP = lib.mkDefault true;
    ipv4.addresses = [ { address = "10.0.2.2"; prefixLength = 24; } ];
  };

  environment.systemPackages = with pkgs; [
    # For debugging and troubleshooting Secure Boot.
    sbctl
    networkmanagerapplet
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  security.tpm2.enable = true;

  boot = {
    # Use upstream rolling kernel for quick bug fixes and performance improvements
    # WARN This might increase power consumption
    # TODO Test impact on a particular common load
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    # Enable emulation for 64-bit ARM and 32-bit x86
    # TODO Inspect if this can be useful to test RISC-V cross-compiled programs
    #binfmt.emulatedSystems = [
    #  "aarch64-linux"
    #  "i686-linux"
    #];
  };

  networking = {
    hostName = config.mySystem.info.hostname;
    # Enable NetworkManager
    networkmanager.enable = true;
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;

    # interfaces.wlp2s0.useDHCP = lib.mkDefault true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Needed for udiskie in HM
  services.udisks2.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = true;  # Enable X11 forwarding
      X11DisplayOffset = 10;
      X11UseLocalhost = false;
      AllowTcpForwarding = true;
      UseDns = true;  # Use DNS for hostname resolution
    };
  };

  users.users.cristi.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGySvc1K+NCd+b/az6ZhtscwM3XO0hnLnB/CWavpow5T"
  ];

}
