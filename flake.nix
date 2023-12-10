{
  description = "Home-manager configuration as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:guibou/nixGL";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, utils, nixgl, ... }:
  # Remove polybar-pipewire overlay
    let
      username = builtins.getEnv "USER";
      homeDirectory = /. + builtins.getEnv "HOME";

      pkgsForSystem = system: import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
          xdg = { configHome = homeDirectory; };
          overlays = [ nixgl.overlay ];
        };
      };

      mkHomeConfiguration = args: home-manager.lib.homeManagerConfiguration (rec {
        pkgs = pkgsForSystem (args.system or "x86_64-linux");
        modules = [
          ./home.nix
          {
            home = {
              # Migrate them to home.nix
              inherit username;
              inherit homeDirectory;
              stateVersion = "23.11";
            };
          }
        ];
      } // args);

    in utils.lib.eachSystem [ "x86_64-linux" ] (system: rec {
      legacyPackages = pkgsForSystem system;
  }) // {
    # non-system suffixed items should go here
    nixosModules.home = import ./home.nix; # attr set or list

    homeConfigurations.cristi = mkHomeConfiguration {
      extraSpecialArgs = {
        withGUI = true;
        isDesktop = true;
      };
    };

    homeConfigurations.lxd = mkHomeConfiguration {
      extraSpecialArgs = {
        withGUI = false;
        isDesktop = false;
      };
    };

    inherit home-manager;

  };
}
