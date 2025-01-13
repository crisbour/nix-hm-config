{ pkgs, ... }:
let
  wall-change = pkgs.writeShellScriptBin "wall-change" (
    builtins.readFile ./wall-change.sh
  );
  wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" (
    builtins.readFile ./wallpaper-picker.sh
  );
  random-wallpaper = pkgs.writeShellScriptBin "random-wallpaper" (
    builtins.readFile ./random-wallpaper.sh
  );

  runbg = pkgs.writeShellScriptBin "runbg" (builtins.readFile ./runbg.sh);
  music = pkgs.writeShellScriptBin "music" (builtins.readFile ./music.sh);
  lofi = pkgs.writeScriptBin "lofi" (builtins.readFile ./lofi.sh);

  toggle_blur = pkgs.writeScriptBin "toggle_blur" (
    builtins.readFile ./toggle_blur.sh
  );
  toggle_oppacity = pkgs.writeScriptBin "toggle_oppacity" (
    builtins.readFile ./toggle_oppacity.sh
  );
  toggle_waybar = pkgs.writeScriptBin "toggle_waybar" (
    builtins.readFile ./toggle_waybar.sh
  );
  toggle_float = pkgs.writeScriptBin "toggle_float" (
    builtins.readFile ./toggle_float.sh
  );

  maxfetch = pkgs.writeScriptBin "maxfetch" (
    builtins.readFile ./maxfetch.sh
  );

  compress = pkgs.writeScriptBin "compress" (
    builtins.readFile ./compress.sh
  );
  extract = pkgs.writeScriptBin "extract" (
    builtins.readFile ./extract.sh
  );

  show-keybinds = pkgs.writeScriptBin "show-keybinds" (
    builtins.readFile ./keybinds.sh
  );

  vm-start = pkgs.writeScriptBin "vm-start" (
    builtins.readFile ./vm-start.sh
  );

  ascii = pkgs.writeScriptBin "ascii" (builtins.readFile ./ascii.sh);

  record = pkgs.writeScriptBin "record" (builtins.readFile ./record.sh);

  screenshot = pkgs.writeScriptBin "screenshot" (
    builtins.readFile ./screenshot.sh
  );

  power-menu = pkgs.writeScriptBin "power-menu" (
    builtins.readFile ./power-menu.sh
  );

  x11-portal = pkgs.writeScriptBin "x11-portal" (
    builtins.readFile ./x11-portal.sh
  );
in
{
  # TODO: Prune what I don't use
  home.packages = with pkgs; [
    wall-change
    wallpaper-picker
    random-wallpaper

    runbg
    music
    lofi

    toggle_blur
    toggle_oppacity
    toggle_waybar
    toggle_float

    maxfetch

    compress
    extract

    show-keybinds

    vm-start

    ascii

    record

    screenshot

    power-menu

    x11-portal
  ];
}
