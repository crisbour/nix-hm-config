{ config, lib, pkgs, pkgs-stable, mach-nix, ... }:
with lib;
let
  tomlFormat = pkgs.formats.toml { };
  iniFormat = pkgs.formats.ini { };
  #hasGUI = config.wayland.enable || config.xorg.enable;
  hasGUI = true;
  exposePort = pkgs.writeShellScriptBin "exposeport" ''
    sudo ssh -L $2:localhost:$2 $1
  '';
in {

  options = {
    devTools.enable = mkEnableOption "developer tools and applications" // {
      default = true;
    };
  };

  config = mkIf config.devTools.enable {
    home.packages = with pkgs;
      [
        # Shell Utilities
        delta
        eternal-terminal        # Remote terminal that reconnest automatically
        exposePort
        jq                      # CLI JSON processor
        mach-nix.packages.${pkgs.system}.mach-nix # mach-nix python declarative env from requirements.txt; Inspired from https://github.com/dejanr/dotfiles/tree/b4e2f70d822fd6bb2ca1f0c7dd450fd938c9de87
        mosh                    # Mobile SSH
        nodePackages.jsonlint
        pre-commit
        tree-sitter
        watchexec
        perf-tools


        # Better Python REPL
        python3Packages.ptpython

        # Languages
        gcc
        gdb
        go
        pkgs-stable.julia
        # Only necesarry for Julia gtk env
        # TODO: Should this be just part of shell.nix?
        glib

        # TODO: Move to rust.nix
        cargo-edit # Easy Rust dependency management
        cargo-graph # Rust dependency graphs
        cargo-watch # Watch a Rust project and execute custom commands upon change
        rustfmt
        clippy

        # Language servers
        clang-tools_17
        cmake
        cmake-language-server

      ] ++ (
        # GUI Tools
        optionals hasGUI [
          dfeet                 # D-Feet is an easy to use D-Bus debugger
          rars                  # RISC-V Assembler and Runtime Simulator
          wireshark

          # GTK Development
          icon-library
        ]);

    # Enable developer programs
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    # TODO: How to use poetry to configure python env?
    #xdg.configFile."pypoetry/config.toml".source =
    #  tomlFormat.generate "config.toml" { virtualenvs.in-project = true; };

  };
}

