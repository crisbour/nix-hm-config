# TODO: Organize flakes better for easy overlays
# - https://github.com/lanice/nixhome/blob/c7067ad78ee9ddbae61e12ffad9f9211ad631be2/flake.nix
{
  description = "Home-manager configuration as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # FIXME: Is there any advantage to use the dev channel instead of what nixpkgs follows?
    #nix-ld ={
    #  url = "github:Mic92/nix-ld";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      # TODO Extract release from nixpkgs.url
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NixOS WSL Support
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar-taskwarrior = {
      url = "github:DestinyofYeet/waybar-taskwarrior.rs";
      # url = "path:///home/ole/github/waybar-taskwarrior.rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # RustUp toolchain
    rust-overlay.url = "github:oxalica/rust-overlay";

    # Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

   # FHS wrappers for Xilinx and Matlab tools
    nix-xilinx.url = "gitlab:doronbehar/nix-xilinx";
    nix-matlab.url = "gitlab:doronbehar/nix-matlab";

    # WindowsApp and other misc, checkout at: https://github.com/emmanuelrosa/erosanix
    erosanix = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waveforms = {
      url = "github:liff/waveforms-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, alacritty-theme, nur, nixgl, nixpkgs-unstable, ... }@inputs:
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
        };
      });
      nixGlOverlay = { ... }: {nixpkgs.overlays = [nixgl.overlay];};
      alacritty-theme-Overlay = { config, pkgs, ... }: {nixpkgs.overlays = [ alacritty-theme.overlays.default ];};
      #nurOverlay = { lib, ... }: {nixpkgs.overlays = [nur.overlay];};

      mkHomeConfiguration = hostModule: system: home-manager.lib.homeManagerConfiguration (rec {
        pkgs = pkgsFor.${system};
        modules = [
          hostModule
          alacritty-theme-Overlay
          # TODO Add nixGlOverlay only to non NixOS
          nixGlOverlay
          #nurOverlay
        ];
        extraSpecialArgs = {
          inherit inputs outputs;
          # TODO: One day maybe when I'll have my own nix derviations organized
          #inherit declarative-cachix;
        };
      } );

    in
    {
      inherit lib;
      nixosModules       = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # TODO: Add templates for languages of interest to minimize time spent on boiler plate code and project init
      # Inspire yourself from: https://github.com/Misterio77/nix-config/tree/main/templates
      #templates = import ./templates;

      overlays = import ./overlays {inherit inputs outputs;};

      packages  = forEachSystem (pkgs: import ./pkgs { inherit pkgs inputs; });
      devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      homeConfigurations = {
        cristi = mkHomeConfiguration ./home/cristi.nix "x86_64-linux";
        work = mkHomeConfiguration ./home/work.nix   "x86_64-linux";
        tiny = mkHomeConfiguration ./home/tiny.nix   "x86_64-linux";
      };

      nixosConfigurations = {
         xps = lib.nixosSystem {
          modules = [./hosts/xps];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        precision = lib.nixosSystem {
          modules = [./hosts/precision];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      # TODO: Port my NixOS configs to this repo as well
      #nixosConfigurations = {
      #  home = mkNixosConfiguration ./hosts/home.nix;
      #};
    };
}
