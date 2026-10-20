{ inputs, config, lib, pkgs, ... }:
with lib;
let
  hasGUI = config.home.user-info.has_gui;
  nix-matlab = pkgs.inputs.nix-matlab;
in {

  imports = [
    #./zed.nix
    ./vscode.nix
    ./latex.nix
    ./hardware-design.nix
    ./julia
    ./openssl-fix.nix
    #../neovim/plugins/spade
    ./unfree.nix
  ];

  options = {
    devTools.enable = mkEnableOption "developer tools and applications" // {
      default = true;
    };
  };

  config = mkIf config.devTools.enable {
    home.packages = with pkgs;
      [
        #(import ./spade-lang.nix { inherit pkgs; })
        binutils
        #difftastic                   # Fantastic diff utility
        cloc
        dbus
        evcxr                         # Rust notebook: Evcxr
        # Shell Utilities
        mosh                    # Mobile SSH
        python313Packages.demjson3
        pre-commit
        tree-sitter
        watchexec
        perf-tools
        tmate
        valgrind                          # c memory analyzer
  #    glances                       # web based `htop`

        # Better Python REPL
        python3Packages.ptpython

        # Languages
        matlab
        gcc
        gdb
        go
        # Only necesarry for Julia gtk env
        # TODO: Should this be just part of shell.nix?
        (  import ./python/python-packages.nix { inherit pkgs; })
        glib
        zig

        ## Rust
        (fenix.complete.withComponents [
          "cargo"
          #"cargo-edit"   # Easy Rust dependency management
          #"cargo-graph" # Rust dependency graphs
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        rust-analyzer-nightly
        cargo-edit
        cargo-watch
        cargo-binstall

        # Kotlin + Java OpenJDK for execution
        kotlin
        zulu

        nix-matlab.matlab-shell # https://gitlab.com/doronbehar/nix-matlab
        nix-matlab.matlab

        # Language servers
        clang-tools
        cmake
        cmake-language-server

        # Debug utils
        usbutils
        pciutils
        xdg-utils
      ] ++ (
        # GUI Tools
        optionals hasGUI [
          # TODO: Move to electronics
          d-spy # dfeet # D-Feet is an easy to use D-Bus debugger but deprecated
          rars                  # RISC-V Assembler and Runtime Simulator
          wireshark

          # GTK Development
          icon-library

          # Inspection tools
          xdot
          #h5v
        ]);

    # TODO: How to use poetry to configure python env?
    #xdg.configFile."pypoetry/config.toml".source =
    #  tomlFormat.generate "config.toml" { virtualenvs.in-project = true; };

  };
}

