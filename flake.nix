{
  description = "Home-manager configuration as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:guibou/nixGL";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nixgl, ... }:
  # Remove polybar-pipewire overlay
    let
      username = builtins.getEnv "USER";
      homeDirectory = /. + builtins.getEnv "HOME";

      pkgsForSystem = system: import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
          xdg = { configHome = homeDirectory; };
        };
        overlays = [
          nixgl.overlay
          # TODO: Better organization: https://github.com/redxtech/dotfiles/blob/03a5dbefcac0db01539ddd3a57d5935739a306b6/.config/home-manager/flake.nix
          (import ./gui/gl_wrapper.nix)
        ];
      };

      mkHomeConfiguration = hostModules: home-manager.lib.homeManagerConfiguration (rec {
        pkgs = pkgsForSystem (args.system or "x86_64-linux");
        modules = [
          ./home.nix
          hostModules
        ];

        # TODO: One day maybe when I'll have my own nix derviations organized
        #extraSpecialArgs = { inherit declarative-cachix; };
      } );

    in {
      homeConfigurations.cristi = mkHomeConfiguration ./host-configurations/cristi.nix;
      homeConfigurations.lxd    = mkHomeConfiguration ./host-configurations/lxd.nix;
    } // (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    {
      legacyPackages = pkgsForSystem system;
    });
}
