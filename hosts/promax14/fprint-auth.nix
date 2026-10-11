{ pkgs, ... }:
{
  # TODO: move to module that enables fprintd-reader
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  security.pam.services = {
    login.enableGnomeKeyring = true;
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    swaylock = {
      unixAuth = true;
      fprintAuth = true;
    };
    hyprlock = {
      unixAuth = true;
      fprintAuth = true;
    };
  };
}
