{
  description = "Home-manager configuration";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs, utils }:
  # Remove polybar-pipewire overlay
    let

      pkgsForSystem = system: import nixpkgs {
        inherit system;
      };

      mkHomeConfiguration = args: home-manager.lib.homeManagerConfiguration (rec {
        pkgs = pkgsForSystem (args.system or "x86_64-linux");
        modules = [
          ./home.nix
          {
            # Migrate them to home.nix
  	        username = builtins.getEnv "USER";
  	        homeDirectory = builtins.getEnv "HOME"; 
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
