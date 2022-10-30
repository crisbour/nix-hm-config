{ config, lib, pkgs, specialArgs, ... }:

let
  bashsettings = import ./modules/bash.nix pkgs;
  vimsettings = import ./vim.nix;
  packages = import ./packages.nix;
  programs = import ./programs.nix;

  # hacky way of determining which machine I'm running this from
  inherit (specialArgs) withGUI isDesktop;

  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux;
in
{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow some or all Unfree packages
  #imports = [ ./config/base.nix ];
  nixpkgs.config.allowUnfree = true;

  home.packages = packages pkgs withGUI;

  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;

  # You can add services as follows:
  #services.<program> = {
  #  enable = true;
  #  ...
  #}

  # Alternative to plain direnv, add watch method to evaluate state of shell
  services.lorri.enable = isLinux;

  services.gpg-agent.enable = isLinux;
  services.gpg-agent.enableExtraSocket = withGUI;
  services.gpg-agent.enableSshSupport = isLinux;

  programs.alacritty = (import ./modules/alacritty/alacritty.nix) lib withGUI;
  programs.bash = bashsettings;
  programs.neovim = vimsettings pkgs;

  # Why do we use both packages and programs versions of direnv 
  programs.direnv.enable = true;
  programs.htop = {
    enable = true;
    settings = {
      left_meters = [ "LeftCPUs2" "Memory" "Swap" ];
      left_right = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
      setshowProgramPath = false;
      treeView = true;
    };
  };
  programs.ssh = {
    enable = true;
    forwardAgent = true;
  };
  programs.fzf.enable = true;

  programs.vscode = mkIf withGUI {
    enable = true;
    package = pkgs.vscode-fhsWithPackages (pkgs: with pkgs; [ zlib rustup ]);
    extensions = with pkgs.vscode-extensions; [
      asciidoctor.asciidoctor-vscode
      vscodevim.vim
      ms-python.python
    ];
  };

  xdg.enable = true;

}
