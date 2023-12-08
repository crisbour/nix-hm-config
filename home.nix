{ config, lib, pkgs, specialArgs, ... }:

let
  # hacky way of determining which machine I'm running this from
  inherit (specialArgs) withGUI isDesktop;
  inherit (pkgs.stdenv) isLinux;

  packages = import ./packages.nix;
in
{
  home.sessionVariables = {
    EDITOR    = "nvim";
    SHELL     = "${pkgs.zsh}/bin/zsh";
    SSH_AUTH_SOCK = lib.mkForce "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";

#    BROWSER = "${pkgs.firefox}/bin/firefox";
  };
  home.packages = packages pkgs withGUI;

  # Allow some or all Unfree packages
  #imports = [ ./config/base.nix ];
  nixpkgs.config.allowUnfree = true;

  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;

  # Allow Nix to handle fonts
  fonts = { fontconfig = { enable = true; }; };

  programs = import ./programs.nix {
    inherit pkgs;
    inherit config;
    inherit lib;
  } withGUI;


  # You can add services as follows:
  #services.<program> = {
  #  enable = true;
  #  ...
  #}

  # Alternative to plain direnv, add watch method to evaluate state of shell
  services.lorri.enable = isLinux;

  services.gpg-agent = {
    enable = isLinux;
    defaultCacheTtl = 36000;
    maxCacheTtl = 36000;
    defaultCacheTtlSsh = 36000;
    maxCacheTtlSsh = 36000;
    enableExtraSocket = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    #pinentryFlavor = "gtk2";
    verbose = true;
    extraConfig = ''
      debug-pinentry
      debug ipc
    '';
  };

  # Be able to use gpg-agent and auth app in the same time: https://whynothugo.nl/journal/2023/03/13/using-a-yubikey-for-both-gpg-and-totp/
  home.file."${config.home.homeDirectory}/.gnupg/scdaemon.conf".text = ''
    pcsc-shared
    #disable-ccid
  '';

  xdg.enable = true;

}
