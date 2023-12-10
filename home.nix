{ config, lib, pkgs, specialArgs, ... }:
with lib.hm.gvariant;
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
    #SSH_AUTH_SOCK = lib.mkForce "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";

  };
  home.packages = packages pkgs withGUI;

  # Allow some or all Unfree packages
  #imports = [ ./config/base.nix ];
  nixpkgs.config.allowUnfree = true;

  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;

  # Keep qemu configuration for virt-manager as shown at: https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

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
    #enableExtraSocket = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentryFlavor = "gnome3";
    verbose = true;
    extraConfig = ''
      debug-pinentry
      debug ipc
    '';
  };

  xdg.enable = true;

  # Gnome look inspired from: https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

}
