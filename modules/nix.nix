{ pkgs, ...}: {
  nixpkgs.config = {
    # TODO Are there packages that I would like and are not in nixpkgs
    #packagesOverrides = pkgs: {
    #  nur = import (builtins.fetchTarball
    #    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    #      inherit pkgs;
    #    };
    #};
    allowUnfree = true;
  };
}