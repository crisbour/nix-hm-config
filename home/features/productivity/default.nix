{ config, lib, pkgs, ... }:
with pkgs;
{
  imports = [
    ./mail.nix
    ./neomutt.nix
    ./newsboat.nix
    ./zotero
  ];

  home.packages = [
    brightnessctl
    evcxr                         # Rust notebook: Evcxr
    graphviz
    engauge-digitizer             # Grapgh to CSV digitizer: Very useful for extracting data from papers

    # Documents
    asciidoctor
    libreoffice
    okular
    quarto
    unstable.joplin-desktop

    # Reference manager
    mendeley

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

