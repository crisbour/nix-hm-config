{ inputs, config, lib, pkgs, ... }:
with lib;
let
  #hasGUI = config.wayland.enable || config.xorg.enable;
  hasGUI = true;
  nix-matlab = pkgs.inputs.nix-matlab;
in {

  imports = [
    ./vscode.nix
    ./latex.nix
    ./hardware-design.nix
    ./julia
  ];

  options = {
    devTools.enable = mkEnableOption "developer tools and applications" // {
      default = true;
    };
  };

  config = mkIf config.devTools.enable {
    home.packages = with pkgs;
      [
        (import ./spade-lang.nix { inherit pkgs; })
        binutils
        #difftastic                   # Fantastic diff utility
        cloc
        dbus
        evcxr                         # Rust notebook: Evcxr
        # Shell Utilities
        inputs.mach-nix.packages.${pkgs.system}.mach-nix # mach-nix python declarative env from requirements.txt; Inspired from https://github.com/dejanr/dotfiles/tree/b4e2f70d822fd6bb2ca1f0c7dd450fd938c9de87
        mosh                    # Mobile SSH
        nodePackages.jsonlint
        pre-commit
        tree-sitter
        watchexec
        perf-tools
        tmate
  #    glances                       # web based `htop`

        # Better Python REPL
        python3Packages.ptpython

        # Languages
        gcc
        gdb
        go
        # Only necesarry for Julia gtk env
        # TODO: Should this be just part of shell.nix?
        (  import ./python/python-packages.nix { inherit pkgs; })
        glib
        rustc
        cargo

        # Kotlin + Java OpenJDK for execution
        kotlin
        zulu

        nix-matlab.matlab-shell # https://gitlab.com/doronbehar/nix-matlab
        nix-matlab.matlab

        # TODO: Move to rust.nix
        cargo-edit # Easy Rust dependency management
        #cargo-graph # Rust dependency graphs
        cargo-watch # Watch a Rust project and execute custom commands upon change
        rustfmt
        clippy

        # Language servers
        clang-tools_17
        cmake
        cmake-language-server

        # Debug utils
        usbutils
        pciutils
        xdg-utils
      ] ++ (
        # GUI Tools
        optionals hasGUI [
          asciidoctor
          # TODO: Move to electronics
          d-spy # dfeet # D-Feet is an easy to use D-Bus debugger but deprecated
          rars                  # RISC-V Assembler and Runtime Simulator
          wireshark

          # GTK Development
          icon-library
        ]);

    # TODO: How to use poetry to configure python env?
    #xdg.configFile."pypoetry/config.toml".source =
    #  tomlFormat.generate "config.toml" { virtualenvs.in-project = true; };

  };
}

