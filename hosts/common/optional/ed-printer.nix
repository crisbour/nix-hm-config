{ pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing.enable = true;
  services.printing.drivers = [
    (pkgs.writeTextDir "share/cups/model/yourppd.ppd" (builtins.readFile ./edprint.ppd))
  ];
}
