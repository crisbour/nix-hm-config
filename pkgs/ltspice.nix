{ inputs, pkgs, ... }:
with (pkgs // pkgs.inputs.erosanix // inputs.erosanix.lib.x86_64-linux);

mkWindowsApp rec {
  #inherit wine;
  wine = wineWowPackages.full;
  pname = "ltspice";
  version = "24.0.12";
  src = fetchurl {
    url = "https://ltspice.analog.com/software/LTspice64.msi";
    sha256 = "sha256-r5P3kW/nDN99mbTklDrmegc3wfIoatmQC8HeAooemH8=";
  };

  #fileMap = {
  #  "$HOME/.config/${pname}/<filename>" = "drive_c/${pname}/<filename>";
  #};

  wineArch = "win64";

  nativeBuildInputs = [
    copyDesktopItems
  #  copyDesktopIcons
  ];

  dontUnpack = true;

  winAppInstall = ''
    echo ${src}
    wine start /unix ${src} /S
  '';

  winAppRun = ''
    wine start /unix "$WINEPREFIX/drive_c/Program Files/LTSpice/LTspice.exe" "$ARGS"
  '';

  installPhase = ''
    runHook preInstall

    ln -s $out/bin/.launcher $out/bin/${pname}

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = "LTSpice";
    exec = "ltspice";
    # mimeTypes = [];
    desktopName = "LTSpice";
    categories = [ "Utility" ];
  };

  #desktopIcon = makeDesktopIcon {
  #  name ="LTSpice";
  #  src = "";
  #};

  meta = {
    description = "LTSpice Circuit simulator";
    homepage = "https://ltspice.analog.com/software";
    platforms = [
      "x86_64-linux"
      "i386-linux"
    ];
  };
}
