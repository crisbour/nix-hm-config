# TODO: Organize flakes better for easy overlays
# - https://github.com/lanice/nixhome/blob/c7067ad78ee9ddbae61e12ffad9f9211ad631be2/flake.nix
{
  description = "Home-manager configuration as a flake";

  inputs = {
    inputs.alacritty-theme.url = "github:alexghr/alacritty-theme.nix";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nixgl, alacritty-theme, ... } @ inputs:
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
          alacritty-theme.overlays.default
          nixgl.overlay
          # TODO: Better organization: https://github.com/redxtech/dotfiles/blob/03a5dbefcac0db01539ddd3a57d5935739a306b6/.config/home-manager/flake.nix
          (import ./nixGL/gl_wrapper.nix)
          # Get around the issue with openssh on RPM distros: https://nixos.wiki/wiki/Nix_Cookbook
          (final: prev: { openssh = prev.openssh_gssapi; } )
        ];
      };

      mkHomeConfiguration = hostModule: home-manager.lib.homeManagerConfiguration (rec {
        pkgs = pkgsForSystem (hostModule.system or "x86_64-linux");
        modules = [
          ./home.nix
        ];

        extraSpecialArgs = { inherit hostModule;};

        # TODO: One day maybe when I'll have my own nix derviations organized
        #extraSpecialArgs = { inherit declarative-cachix; };
      } );

    in
    {
      homeConfigurations.cristi = mkHomeConfiguration ./host-configurations/cristi.nix;
      homeConfigurations.lxd    = mkHomeConfiguration ./host-configurations/lxd.nix;
    } // (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
        pkgs = pkgsForSystem system;
    in
    {
        devShells.default = pkgs.mkShell {
            packages = with pkgs; [
                black
                cargo
                git-crypt
                nixfmt
                pre-commit
                rnix-lsp
            ];
        };
    }));
}
