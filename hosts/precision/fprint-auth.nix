{ pkgs, ... }:
{
  # TODO: move to module that enables fprintd-reader
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
