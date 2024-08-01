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
}
