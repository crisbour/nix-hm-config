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
    graphviz

#    openssl
    evcxr                         # Rust notebook: Evcxr
    rust-analyzer

    asciidoctor
    brightnessctl
    #flameshot
    unstable.joplin-desktop
    libreoffice
    mendeley
    okular
    #shutter # screenshots

    # TODO Move to media
    spotify

    tmate

    # TODO: Perhaps use these with touchscreen display laptop
    #write_stylus
    #xournal
  ];
}

