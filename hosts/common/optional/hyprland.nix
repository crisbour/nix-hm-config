{ pkgs, config, lib, inputs, ... }:
{
  #environment.systemPackages = [
  #  pkgs.ghostty
  #];

  imports = [
    inputs.hyprland.nixosModules.default
  ];

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
  ];

  # greetd display manager
  # Partially inspired from: https://github.com/Aylur/dotfiles/blob/ags-pre-ts/nixos/hyprland.nix
  services.xserver.displayManager.startx.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = lib.getExe' config.programs.hyprland.package "start-hyprland";
        user = "cristi";
      };
      default_session = initial_session;
    };
  };

  # unlock GPG keyring on login
  #security.pam.services.greetd.enableGnomeKeyring = true;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

}
