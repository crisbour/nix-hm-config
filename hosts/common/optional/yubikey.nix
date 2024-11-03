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
  services.keybase.enable = true;

  # Enable u2f over USB, for yubikey auth in browser
  #hardware.u2f.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
    yubikey-personalization-gui
    yubioath-flutter
    yubikey-manager
  ];

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  security.pam.u2f = {
    enable = true;
    interactive = true;
    control = "sufficient";
    cue = true;
  };

  security.pam.services = {
    login.u2fAuth = false;
    sudo.u2fAuth = true;
  };

  security.pam.yubico = {
     enable = true;
     #debug = true;
     mode = "challenge-response";
     id = [ "25552783" ];
  };
}

# Taken from: https://github.com/jonaswouters/nixos-configuration/blob/master/yubikey.nix
