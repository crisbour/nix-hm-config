{ pkgs, ... }:
let
  configData = builtins.fromJSON (builtins.readFile ./config.json);
  schemaUpdatedConfig = configData // {
    "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
  };
in
{
  # TODO: Perhaps one day will switch to eww: https://github.com/gasech/hyprland-dots?tab=readme-ov-file
  home.packages = (with pkgs; [ swaynotificationcenter ]);
  xdg.configFile."swaync/style.css".source = ./style.css;
  # xdg.configFile."swaync/config.json".source = ./config.json;
  # Inspired from: https://gist.github.com/Kvn0l/4f0470ef312e4c74284755259a8d41f5
  xdg.configFile."swaync/config.json".source = pkgs.writeText "config.json"
    (builtins.toJSON schemaUpdatedConfig);
}
