{ config, pkgs, stdenv, lib, ... }:
let
  my-rofi = pkgs.rofi.override {
    plugins = with pkgs; [
      # rofi-file-browser
    ];
  };
in
{
  #home.packages = with pkgs; [
  #  rofi
  #  rofi-systemd
  #  rofi-pass
  #  rofi-power-menu
  #  #pkgs.inputs.nur.repos.peel.rofi-wifi-menu
  #  #pkgs.inputs.nur.repos.peel.rofi-emoji
  #];
  home.packages = with pkgs; [
    rofi-pass
  ];
  programs.rofi = {
    enable = true;
    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-emoji
      pkgs.rofi-systemd
      #pkgs.rofi-themes
    ];
    #package = my-rofi;
    theme = "DarkBlue";
    extraConfig = {
      modi = "run,emoji,calc";
      font = "mono 20";
    };
  };

  # gnome keyboard shortcuts
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-window/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-pass/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-run/"
    ];
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-window" = {
      binding="<Super>space";
      command="rofi -show window";
      name="rofi window";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-pass" = {
      name = "rofi-pass";
      command = "rofi-pass";
      binding = "<Ctrl><Super>s";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-run" = {
      name = "rofi launcher";
      command = "rofi -show run -display-run 'run: '";
      binding = "<Ctrl><Super>space";
    };
  };
  #home.file.rofi_config = {
  #  target = ".config/rofi/config.rasi";
  #  text = ''
  #    /* This is a comment */
  #    /* rofi -dump-config */
  #    @theme "gruvbox-dark"

  #    configuration {
  #      modes: [
  #        window,
  #        drun,
  #        run,
  #        ssh
  #        /* file-browser-extended */
  #      ];
  #      terminal: "alacritty";
  #      dpi: 1;
  #      show-icons: true;
  #    }
  #    filebrowser {
  #      directory: "~/Documents";
  #    }

  #    /* man rofi-theme */

  #    window {
  #      width: 80%;
  #    }
  #  '';
  #};

  # home.file.rofi_file_browser_config = let
  #   openDir = pkgs.writeScript "openDir" ''
  #     if [[ -d "$1" ]]; then
  #       xdg-open "$1"
  #     elif [[ -f "$1" ]]; then
  #       xdg-open "''${1%/*}"
  #     fi
  #   '';
  # in {
  #   target = ".config/rofi/file-browser";
  #   text = ''
  #     # This is a comment
  #     dir ~/Documents
  #     depth 0
  #     no-sort-by-type
  #     sort-by-depth

  #     # BUG: rofi -show-icons causes segmentation fault
  #     # oc-search-path
  #     # oc-cmd "nautilus"
  #     # oc-cmd "${openDir}"
  #   '';
  # };
}
