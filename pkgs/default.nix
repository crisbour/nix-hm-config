# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, inputs, ... }:
let
  extra-inputs = {
    inherit
      inputs
      pkgs;
  };
in
{
  ltspice = pkgs.callPackage ./ltspice.nix { inherit pkgs inputs; };
  zotero-addons = pkgs.callPackage ./zotero-addons.nix { inherit pkgs; };
  rofi-emoji-wayland = pkgs.callPackage ./rofi-emoji-wayland {};
  rofi-calc-wayland = pkgs.callPackage ./rofi-calc-wayland {};
}
