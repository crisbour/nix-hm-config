{ config, lib, pkgs, ... }:
with pkgs;
{
  imports = [
    ./mail.nix
    ./neomutt.nix
    ./newsboat.nix
    ./zotero
    ./taskwarrior
  ];

  home.packages = [
    brightnessctl
    evcxr                         # Rust notebook: Evcxr
    graphviz
    engauge-digitizer             # Grapgh to CSV digitizer: Very useful for extracting data from papers
    kdePackages.kcalc

    # Documents
    asciidoctor
    libreoffice
    kdePackages.okular
    quarto
    joplin-desktop
    recoll

    rust-analyzer

    # Desktop interaction
    #shutter # screenshots
    #flameshot

    # TODO Move to media
    spotify

    tmate

    # TODO: Perhaps use these with touchscreen display laptop
    #write_stylus
    #xournal
  ];
}

