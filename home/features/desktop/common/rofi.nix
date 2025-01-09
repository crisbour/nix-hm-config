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
  #  #pkgs.inputs.nur.repos.peel.rofi-wifi-menu
  #  #pkgs.inputs.nur.repos.peel.rofi-emoji
  #];
  home.packages = with pkgs; [
    rofi-pass
    rofi-power-menu
    rofi-screenshot
    #nur.repos.peel.rofi-wifi-menu
    #nur.repos.peel.rofi-emoji
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [
      #pkgs.rofi-calc
      pkgs.rofi-emoji-wayland
      pkgs.rofi-systemd
      #pkgs.rofi-themes
    ];
    #package = my-rofi;
    theme = "DarkBlue";
  };

  xdg.configFile."rofi/theme.rasi".text = ''
    * {
      bg-col: #1D2021;
      bg-col-light: #282828;
      border-col: #A89984;
      selected-col: #3C3836;
      green: #98971A;
      fg-col: #FBF1C7;
      fg-col2: #EBDBB2;
      grey: #BDAE93;
      highlight: @green;
    }
  '';

  xdg.configFile."rofi/config.rasi".text = ''
    configuration{
      modi: "run,drun,window";
      lines: 5;
      cycle: false;
      font: "JetBrainsMono NF Bold 15";
      show-icons: true;
      icon-theme: "Papirus-dark";
      terminal: "alacritty";
      drun-display-format: "{icon} {name}";
      location: 0;
      disable-history: true;
      hide-scrollbar: true;
      display-drun: " Apps ";
      display-run: " Run ";
      display-window: " Window ";
      /* display-Network: " Network"; */
      sidebar-mode: true;
      sorting-method: "fzf";
    }

    @theme "theme"

    element-text, element-icon , mode-switcher {
      background-color: inherit;
      text-color:       inherit;
    }

    window {
      height: 600px;
      width: 900px;
      border: 2px;
      border-color: @border-col;
      background-color: @bg-col;
    }

    mainbox {
      background-color: @bg-col;
    }

    inputbar {
      children: [prompt,entry];
      background-color: @bg-col-light;
      border-radius: 5px;
      padding: 0px;
    }

    prompt {
      background-color: @green;
      padding: 4px;
      text-color: @bg-col-light;
      border-radius: 3px;
      margin: 10px 0px 10px 10px;
    }

    textbox-prompt-colon {
      expand: false;
      str: ":";
    }

    entry {
      padding: 6px;
      margin: 10px 10px 10px 5px;
      text-color: @fg-col;
      background-color: @bg-col;
      border-radius: 3px;
    }

    listview {
      border: 0px 0px 0px;
      padding: 6px 0px 0px;
      margin: 10px 0px 0px 6px;
      columns: 3;
      background-color: @bg-col;
      cycle: true;
    }

    element {
      padding: 8px;
      margin: 0px 10px 4px 4px;
      background-color: @bg-col;
      text-color: @fg-col;
    }

    element-icon {
      size: 28px;
    }

    element selected {
      background-color:  @selected-col ;
      text-color: @fg-col2  ;
      border-radius: 3px;
    }

    mode-switcher {
      spacing: 0;
    }

    button {
      padding: 10px;
      background-color: @bg-col-light;
      text-color: @grey;
      vertical-align: 0.5;
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @green;
    }
  '';

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
