{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./git.nix
    ./ssh.nix
    ./gpg.nix
    ./zsh
    ./dircolors.nix
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

  home.packages = with pkgs; [
    bat # Improved cat TODO add base16 colors?
    bc # Calculator
    bottom # System viewer (htop on steroids)
    comma # Install and run programs by sticking a , before them
    delta #  Syntax aware diff
    diffsitter # Better diff
    #distrobox # Nice escape hatch, integrates docker images with my environment
    eza # Better ls, written in Rust
    fd # Better find => TODO add alias
    file
    gnumake
    httpie # Better curl => # TODO: add alias curl = httpie
    jq # JSON pretty printer and manipulator
    lf                            # Terminal file manager inspired by ranger
    libnotify
    manix                         # Nix search documentation
    most # Better than less and more
    ncdu # TUI disk usage
    perl                          # for fzf history
    ripgrep # Better grep
    tig                           # Awesome Text based git
    tre # Improved `tree` written in Rust TODO: Add alias?
    #timer # To help with my ADHD paralysis
    wget
    unzip
    zip

    # TODO: Review the Nix tools, what they are useful for and how to use them
    nil # Nix LSP
    nixfmt # Nix formatter
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
