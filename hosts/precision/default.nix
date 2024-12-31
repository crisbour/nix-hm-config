{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/optional/desktop.nix
    ../common/users/cristi.nix
    ../common/optional/gpu.nix
    ../common/optional/fonts.nix
    ../common/optional/yubikey.nix
    ../common/optional/udev.nix
    ../common/optional/docker.nix
    ../common/optional/gitlab-runner.nix
    # WARN Cannot use nvidia driver and vfio concurently
    ../common/optional/kvm.nix
    ../common/optional/lxd.nix
    # UoE VPN and CIFS
    ../common/optional/fortivpn.nix
    ../common/optional/uoe-cifs.nix
  ];


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
  services.logind = {
    extraConfig = ''
      HandleLidSwitch=suspend
    '';
  };

  networking = {
    hostName = "precision";
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

  # Needed for udiskie in HM
  services.udisks2.enable = true;

  security.polkit.enable = true;
  security.polkit.debug = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
      if (action.id === "org.freedesktop.policykit.exec" &&
          action.lookup("program") === "/usr/local/bin/batteryhealthchargingctl-cristi"
      )
      {
        return polkit.Result.YES;
      }
    })
  '';
  environment.systemPackages = with pkgs; [
    libsmbios
    #dell-command-configure
    gnomeExtensions.battery-health-charging
    polkit
    polkit_gnome
  ];
}
