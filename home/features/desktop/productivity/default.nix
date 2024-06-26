{ config, lib, pkgs, ... }:
with pkgs;
{
  imports = [
    ./newsboat.nix
  ];

  home.packages = [
    graphviz

#    openssl
    evcxr                         # Rust notebook: Evcxr
    rust-analyzer

    asciidoctor
    brightnessctl
    #flameshot
    joplin-desktop
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

