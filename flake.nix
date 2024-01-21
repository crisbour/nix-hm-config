# TODO: Organize flakes better for easy overlays
# - https://github.com/lanice/nixhome/blob/c7067ad78ee9ddbae61e12ffad9f9211ad631be2/flake.nix
{
  description = "Home-manager configuration as a flake";

  inputs = {
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mach-nix.url = "github:DavHau/mach-nix";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nix User Repository
    nur.url = "github:nix-community/NUR";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, mach-nix, nixgl, alacritty-theme, nixpkgs-unstable, ... }@inputs:
  # Remove polybar-pipewire overlay
    let
      inherit (self) outputs;

      # TODO: Is this necessary? Perhaps for accessing home-manager.lib.homeManagerConfiguration easier
      lib = nixpkgs.lib // home-manager.lib;

      systems = [ "aarch64-linux" "x86_64-linux" ];

      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # TODO: Is this necessary?
          #xdg = { configHome = homeDirectory; };
        };
      });
      nixGlOverlay = {config, ...}: {nixpkgs.overlays = [nixgl.overlay];};

      alacritty-theme-Overlay = { config, pkgs, ... }: {nixpkgs.overlays = [ alacritty-theme.overlays.default ];};

      mkHomeConfiguration = hostModule: system: home-manager.lib.homeManagerConfiguration (rec {
        pkgs = pkgsFor.${system};
        modules = [
          hostModule
          alacritty-theme-Overlay
        ];
        extraSpecialArgs = {
          inherit inputs outputs;
          # TODO: One day maybe when I'll have my own nix derviations organized
          #inherit declarative-cachix;
        };
      } );

    in
    {
      nixosModules       = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # TODO: Add templates for languages of interest to minimize time spent on boiler plate code and project init
      # Inspire yourself from: https://github.com/Misterio77/nix-config/tree/main/templates
      #templates = import ./templates;

      overlays = import ./overlays {inherit inputs outputs;};

      packages  = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      homeConfigurations = {
        cristi = mkHomeConfiguration ./home/cristi.nix "x86_64-linux";
        work = mkHomeConfiguration ./home/work.nix   "x86_64-linux";
        tiny = mkHomeConfiguration ./home/tiny.nix   "x86_64-linux";
      };

      # TODO: Port my NixOS configs to this repo as well
      #nixosConfigurations = {
      #  home = mkNixosConfiguration ./hosts/home.nix;
      #};
    };
}
