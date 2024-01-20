{ config, lib, pkgs, ... }:
with pkgs;
let
  inherit (pkgs.stdenv) isLinux;
  #hasGui = config.wayland.enable || config.xorg.enable;
  hasGUI = true;
  # Nerdfonts is huge: take only what you need
  #nerdfonts = (pkgs.nerdfonts.override { fonts = [
  #    "FiraCode"
  #    "DroidSansMono"
  #    "Iosevka"
  #    "Monokai"
  #]; });
in
{
  home.packages = [
    bat
    binutils
    bottom                       # htop on steroids
    delta
    #difftastic                   # Fantastic diff utility
    cloc
    curl
    dbus
    # TODO: alias ls=eza
    eza                           # `ls` replacement written in Rust
    evcxr                         # Rust notebook: Evcxr
    # TODO: alias find=fd
    fd                            # `find` alternative, faster and simpler
    file
#    git
#    glances                       # web based `htop`
    gnumake

    keybase

    libnotify

    manix                         # Nix search documentation
    most

    nerdfonts

    nix-index                     # Find packages providing a binary name
    nix-template                  # Generate deterministic derivation templates
    nix-update                    # Update nixpkgs
#    nixpkgs-review-fixed          # Rebuild packages with changes/overlays
    nodejs                        # needed for coc vim plugins
#    openssl
    pciutils
    perl                          # for fzf history
 (  import ../pkgs/python-packages.nix { inherit pkgs; })
 # TODO: Perhaps configure it like here: https://github.com/HugoReeves/nix-home/blob/0b044c15b7fb597e1480cd266ea25599706fb9e9/program/file-manager/ranger/index.nix#L4
#    ranger                        # Terminal file manager
    lf                            # Terminal file manager inspired by ranger

    # FIXME: Move language server to nvim
    rnix-lsp                      # Nix language server
    rust-analyzer

    tig                           # Awesome Text based git
    tree
    wget

    # vim plugin dependencies
    ripgrep
    unzip
    usbutils
    zip
    xdg-utils
    xclip
  ] ++ lib.optionals hasGUI [
    asciidoctor
    brightnessctl
    discord
    #flameshot
    joplin-desktop
    mendeley
    okular
    #shutter # screenshots
    slack
    spotify
    teams-for-linux
    tmate

    # TODO: Perhaps use these with touchscreen display laptop
    #write_stylus
    #xournal

    # Graph drawing
    (import ../gui/yed.nix { inherit pkgs; })

    # for work
    freerdp

  ];

  programs = {

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

    dircolors = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = __readFile (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/trapd00r/LS_COLORS/bcf78f74be4788ef224eadc7376ca780ae741e1e/LS_COLORS";
          hash = "sha256-itKCWFPpJcTbw25DZCY7dktZh7/hU9RLHCmRLXvksno=";
        });
    };

    # Terminal workspace more powerfull than tmux
    # TODO: Nice configuration: https://github.com/budimanjojo/dotfiles
    zellij = {
      enable = true;
    };

    # Better cd
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };


    # Why do we use both packages and versions of direnv
    #direnv= {
    #  enable = true;
    #  enableZshIntegration = true;

    #  stdlib = ''
    #    use_riff() {
    #      watch_file Cargo.toml
    #      watch_file Cargo.lock
    #      eval "$(riff print-dev-env)"
    #      }
    #    '';
    #  nix-direnv.enable = true;
    #};
  };

  # TODO Move programs and config in a single place
  home.file.zellij = {
    target = ".config/zellij/config.kdl";
    source = ../config/config.kdl;
  };

}

