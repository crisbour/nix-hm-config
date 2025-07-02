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
    inputs.hardware.nixosModules.common-gpu-nvidia
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
    #../common/optional/gitlab-runner.nix
    # WARN: Cannot use nvidia driver and vfio concurently
    ../common/optional/kvm.nix
    ../common/optional/gpu.nix
    # UoE VPN and CIFS
    ../common/optional/fortivpn.nix
    ../common/optional/uoe-cifs.nix
    ../common/optional/ed-printer.nix

    # Temporary DHCP server
    #../common/optional/dnsmasq.nix

    ./fprint-auth.nix
    ./services
    ./sops.nix
  ];

  mySystem.info = {
    hostname = "precision";
    has_gui = true;
    has_nvidia = true;
    has_intel = true;
  };

  hardware.enableAllFirmware = lib.mkDefault true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  mySystem.incus = {
    enable = true;
    serverAddr = "${config.mySystem.info.hostname}.hyena-royal.ts.net";
    # Needed to let remote local: push to another remote
    enableServer = true;
  };
  networking.firewall.allowedTCPPorts = [ 8443 ];

  services.logind = {
    # Already defined in hibernate-resume
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
    extraConfig = ''
      HandlePowerKey=suspend
    '';
  };

  networking = {
    hostName = config.mySystem.info.hostname;
    # Enable NetworkManager
    networkmanager.enable = true;
    #interfaces.enp0s13f0u1u4.macAddress = "${config.sops.placeholder."uoe_mac".path}";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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


  programs.adb.enable = true;
  users.users.cristi.extraGroups = ["adbusers"];
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.ddcutil
  ];

  # Necessary for Fusion360
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    sbctl
    dcfldd
    ddcutil
    libsmbios
    dell-command-configure
    networkmanagerapplet
  ];

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

  # --------------- SOPS -------------------
  sops.secrets."uoe_mac" = {};
}
