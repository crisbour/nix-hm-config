{ ... }:
{
  imports = [
    ./settings.nix
    ./style.nix
  ];

  programs.waybar = {
    enable = true;
  };

  # TODO: Find what experimental features there are to trade for build time
  #programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
  #  mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
  #});
}
