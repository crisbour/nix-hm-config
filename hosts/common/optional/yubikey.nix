{ config, lib, pkgs, ... }:
#let
#  unstable = import <nixos-unstable> {};
#in
{

  #nixpkgs.config = {
  #    packageOverrides = pkgs: {
  #      pcscd = unstable.pcscd;
  #  };
  #};

  programs.ssh.startAgent = false;

  #services.yubikey-agent.enable = true;

  # Enable smartcard daemon, to read TOPT tokens from yubikey
  services.pcscd = {
    enable = true;
    plugins = with pkgs; [ libykneomgr ccid ];
  };

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubico-pam
    # GUI
    yubikey-personalization-gui
    yubioath-flutter
  ];

  # add udev rules for yubikey personalization
  services.udev.packages = with pkgs; [ yubikey-personalization ];

   # enable smartcard support
  hardware.gpgSmartcards.enable = true;

  # enable polkit to use yubikey for authentication
  security.polkit.enable = true;

  security.pam.services = {
    login.u2fAuth = false;
    sudo.u2fAuth = true;
  };

  security.pam.yubico = {
     enable = true;
     #debug = true;
     mode = "challenge-response";
     id = [ "11066999" ];
  };
}

# Taken from: https://github.com/jonaswouters/nixos-configuration/blob/master/yubikey.nix
