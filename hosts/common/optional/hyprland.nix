{ pkgs, config, lib, ... }:
{
  #environment.systemPackages = [
  #  pkgs.ghostty
  #];

  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

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

  # greetd display manager
  # Partially inspired from: https://github.com/Aylur/dotfiles/blob/ags-pre-ts/nixos/hyprland.nix
  services.xserver.displayManager.startx.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  services.greetd = let
    session = {
      command = "${lib.getExe config.programs.hyprland.package}";
      user = "cristi";
    };
  in {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
    };
  };

  # unlock GPG keyring on login
  #security.pam.services.greetd.enableGnomeKeyring = true;
}
