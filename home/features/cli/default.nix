{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./git.nix
    ./fzf.nix
    ./zsh
    ./zellij
    ./dircolors.nix
    ./tmux
    ./screen.nix
    ./yazi.nix
    #./fastfetch.nix
    # TODO, add some more interesting packages from here: https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/cli/default.nix
    # - shellcolor
    # - lyrics
    # - jujutsu
    # - gh => glab for work => Switch between them based on origin url
  ];

  programs = {

    # TODO: Move in base
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

    # Better cd
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv= {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      #stdlib = ''
      #  use_riff() {
      #    watch_file Cargo.toml
      #    watch_file Cargo.lock
      #    eval "$(riff print-dev-env)"
      #    }
      #  '';
    };
  };

  home.packages = with pkgs; [
    bat        # Improved cat TODO add base16 colors?
    bc         # Calculator
    bottom     # System viewer (htop on steroids)
    btop       # Better htop
    caligula   # User-friendly, lightweight TUI for disk imaging
    comma      # Install and run programs by sticking a , before them
    delta      # Syntax aware diff
    diffsitter # Better diff
               # distrobox      # Nice escape hatch, integrates docker images with my environment
    eza        # Better ls, written in Rust
    fd         # Better find => TODO add alias
    file
    gnumake
    httpie     # Better curl => # TODO: add alias curl = httpie
    jq         # JSON pretty printer and manipulator
    just       # Run justfiles: Better makefile alternative written in Rust
    killall
    libnotify
    lorri
    manix      # Nix search documentation
    most       # Better than less and more
    ncdu       # TUI disk usage
    fastfetch  # Like neofetch but gets info for more Unix systems
    cpufetch # CPU Info like neofetch
    pamixer                           # pulseaudio command line mixer
    perl       # for fzf history
    playerctl                         # controller for media players
    poweralertd
    ripgrep    # Better grep
    sops
    tdf                               # cli pdf viewg
    tig        # Awesome Text based git
    tre        # Improved `tree` written in Rust TODO: Add alias?
    #timer      # To help with my ADHD paralysis
    wget
    unzip
    zip

    # TODO: Review the Nix tools, what they are useful for and how to use them
    nil # Nix LSP
    nixfmt-rfc-style # Nix formatter
    nvd # Differ
    nix-output-monitor
    #nh # Nice wrapper for NixOS and HM

    nix-index                     # Find packages providing a binary name
    nix-template                  # Generate deterministic derivation templates
    nix-update                    # Update nixpkgs
#    nixpkgs-review-fixed          # Rebuild packages with changes/overlays

    #ltex-ls # Spell checking LSP

    #tly # Tally counter
  ];

}
