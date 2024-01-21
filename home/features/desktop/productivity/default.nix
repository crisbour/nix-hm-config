{ config, lib, pkgs, ... }:
with pkgs;
{
  imports = [
    ./newsboat.nix
  ];

  home.packages = [
#    openssl
    evcxr                         # Rust notebook: Evcxr
    rust-analyzer

    asciidoctor
    brightnessctl
    #flameshot
    joplin-desktop
    mendeley
    okular
    #shutter # screenshots
    spotify
    tmate

    # TODO: Perhaps use these with touchscreen display laptop
    #write_stylus
    #xournal

    # Graph drawing
    (import ../gui/yed.nix { inherit pkgs; })
  ];
}

