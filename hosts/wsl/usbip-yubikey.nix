{
  pkgs,
  lib,
  ...
}:
with lib; let
  usbipd-win-auto-attach = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dorssel/usbipd-win/v3.1.0/Usbipd/wsl-scripts/auto-attach.sh";
    hash = "sha256-KJ0tEuY+hDJbBQtJj8nSNk17FHqdpDWTpy9/DLqUFaM=";
  };
in {
  environment.systemPackages = [
    pkgs.linuxPackages.usbip
    pkgs.yubikey-manager
    pkgs.libfido2
  ];

  services.pcscd.enable = true;
  services.udev = {
    enable = true;
    packages = with pkgs; [
      libu2f-host
      yubikey-personalization
    ];
    extraRules = ''
      SUBSYSTEM=="usb", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess", MODE="0666"

      SUBSYSTEM=="usb", ATTRS{idVendor}=="1050", GROUP="plugdev", MODE="0660"
    '';
  };

  users.users.cristi.extraGroups = ["plugdev"];

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.debian.pcsc-lite.access_pcsc" ||
          action.id == "org.debian.pcsc-lite.access_card") {
        return polkit.Result.YES;
      }
    });
  '';

  #systemd = {
  #  services."usbip-auto-attach@" = {
  #    description = "Auto attach device having busid %i with usbip";
  #    after = ["network.target"];

  #    scriptArgs = "%i";
  #    path = [pkgs.linuxPackages.usbip];

  #    script = ''
  #      busid="$1"
  #      ip="$(grep nameserver /etc/resolv.conf | cut -d' ' -f2)"

  #      echo "Starting auto attach for busid $busid on $ip."
  #      source ${usbipd-win-auto-attach} "$ip" "$busid"
  #    '';
  #  };

  #  targets.multi-user.wants = map (busid: "usbip-auto-attach@${busid}.service") cfg.autoAttach;
  #};
}

