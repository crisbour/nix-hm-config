{ pkgs, config, lib, withGUI, ... }:
let
  bashsettings = import ./modules/bash.nix pkgs;
  vimsettings = import ./modules/vim.nix;
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux;
in
{
  alacritty = (import ./modules/alacritty/alacritty.nix) {
    inherit config;
    inherit lib;
    inherit pkgs;
  } withGUI;

  bash = bashsettings;
  neovim = vimsettings pkgs;

  # Why do we use both packages and versions of direnv
  direnv= {
    enable = true;
    enableZshIntegration = true;

    stdlib = ''
      use_riff() {
        watch_file Cargo.toml
        watch_file Cargo.lock
        eval "$(riff print-dev-env)"
        }
      '';
    nix-direnv.enable = true;
  };

  dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

#  git = import ./git.nix { inherit pkgs; };

  # Let Home Manager install and manage itself.
  home-manager.enable = true;

  htop = {
    enable = true;
    settings = {
      left_meters = [ "LeftCPUs2" "Memory" "Swap" ];
      left_right = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
      setshowProgramPath = false;
      treeView = true;
    };
  };

  ssh = {
    enable = true;
    forwardAgent = true;
  };

  fzf.enable = true;

  vscode = mkIf withGUI {
    enable = true;
    package = pkgs.vscode-fhsWithPackages (pkgs: with pkgs; [ zlib rustup ]);
    extensions = with pkgs.vscode-extensions; [
      asciidoctor.asciidoctor-vscode
      vscodevim.vim
      ms-python.python
    ];
  };

  # Terminal workspace more powerfull than tmux
  zellij = {
    enable = true;
    settings = { };
  };

  # Better cd
  zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ ];
  };

}
