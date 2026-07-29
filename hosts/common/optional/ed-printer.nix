{ pkgs, ... }:
let
  edprintDriver = pkgs.stdenv.mkDerivation {
    pname = "edprint-ppd";
    version = "1.0";

    src = ./edprint.ppd;

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/cups/model
      cp $src $out/share/cups/model/edprint.ppd
    '';
  };
in
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  users.users.cristi = {
    extraGroups = [ "lpadmin" ];
  };

  services.printing = {
    enable = true;

    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;

    drivers = [
      pkgs.gutenprint
      pkgs.cups-filters
      pkgs.cups-browsed
      edprintDriver
    ];
  };

  environment.systemPackages = with pkgs; [
    cups
    system-config-printer
  ];

  hardware.printers = {
    ensurePrinters = [
      {
        name = "EdPrintPull";
        location = "University of Edinburgh";
        description = "EdPrintPull MobilityPrint find-me printing";

        deviceUri = "https://edprint.is.ed.ac.uk:9164/printers/EdPrintPull";

        # Replace this path with wherever you store the downloaded PPD.
        model = "edprint.ppd";

        ppdOptions = {
          ColorModel = "Gray";
          Staple = "False";
        };
      }
    ];

    ensureDefaultPrinter = "EdPrintPull";
  };

  #services.printing.drivers = [
  #  (pkgs.writeTextDir "share/cups/model/yourppd.ppd" (builtins.readFile ./edprint.ppd))
  #];
}
