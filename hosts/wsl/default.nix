{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    #./hardware.nix
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
    ../common/global
    ../common/users/cristi.nix
    ../common/optional/fonts.nix
    # FIXME: YubiKey for WSL passthrough
    #../common/optional/yubikey.nix
    #./usbip.nix
    # FIXME: Passthrough USB devices to WSL
    #../common/optional/udev.nix
    # FIXME: Investigate how docker runs under WSL in NixOS?
    #../common/optional/docker.nix
    # TODO: Setup gitlab-runner for this WSL machine
    #../common/optional/gitlab-runner.nix
  ];

  nixpkgs.hostPlatform.system = "x86_64-linux";

  wsl = {
    enable = true;
    defaultUser = "cristi";
    usbip = {
      enable = true;
      # Replace this with the BUSID for your Yubikey
      #autoAttach = ["9-4"];
    };
    extraBin = with pkgs; [
      { src = "${coreutils}/bin/uname"; }
      { src = "${coreutils}/bin/dirname"; }
      { src = "${coreutils}/bin/readlink"; }
      { src = "${coreutils}/bin/cat"; }
      { src = "${coreutils}/bin/sed"; }
      { src = "${bash}/bin/bash"; }
    ];
  };

  services.vscode-server.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  boot = {
    # Use upstream rolling kernel for quick bug fixes and performance improvements
    # WARN This might increase power consumption
    # TODO Test impact on a particular common load
    #kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    # Enable emulation for 64-bit ARM and 32-bit x86
    # TODO Inspect if this can be useful to test RISC-V cross-compiled programs
    #binfmt.emulatedSystems = [
    #  "aarch64-linux"
    #  "i686-linux"
    #];
  };

  networking = {
    hostName = "wsl";
    # Enable NetworkManager
    networkmanager.enable = true;
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

  environment.systemPackages = [
    pkgs.bash
    pkgs.wget
  ];


  system.stateVersion = "24.11";
}
