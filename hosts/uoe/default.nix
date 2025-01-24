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
    #../common/optional/gpu.nix
    ../common/optional/fonts.nix
    #../common/optional/yubikey.nix
    ../common/optional/udev.nix
    #../common/optional/docker.nix
    #../common/optional/gitlab-runner.nix
    # WARN: Cannot use nvidia driver and vfio concurently
    #../common/optional/kvm.nix
    # UoE VPN and CIFS
    #../common/optional/fortivpn.nix
    #../common/optional/uoe-cifs.nix
  ];

  mySystem.info = {
    hostname = "w9098";
    has_gui = true;
    has_intel = true;
  };

  hardware.enableAllFirmware = lib.mkDefault true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  environment.systemPackages = with pkgs; [
    # For debugging and troubleshooting Secure Boot.
    sbctl
    networkmanagerapplet
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

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
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

}
