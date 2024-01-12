pkgs: withGUI: with pkgs; [
  # these files are meant to be installed in all scenarios
  bat
  binutils
  bottom                       # htop on steroids
  difftastic                   # Fantastic diff utility

  cargo-edit # Easy Rust dependency management
  cargo-graph # Rust dependency graphs
  cargo-watch # Watch a Rust project and execute custom commands upon change

  clang-tools_17

  cloc

  cmake
  cmake-language-server

  dbus
  eza                           # `ls` replacement written in Rust
  evcxr                         # Rust notebook: Evcxr
  fd                            # `find` alternative, faster and simpler
#  git
  gitAndTools.delta
#  glances                       # web based `htop`
  gnupg                         # gpg command
  gnumake
  go

  julia
#  jupyter

  keybase

  manix                         # Nix search documentation
  most
  nix-index                     # Find packages providing a binary name
  nix-template                  # Generate deterministic derivation templates
  nix-update                    # Update nixpkgs
#  nixpkgs-review-fixed          # Rebuild packages with changes/overlays
  nodejs                        # needed for coc vim plugins
  perl                          # for fzf history
#  pinentry
 (import ./modules/python-packages.nix { inherit pkgs; })
#  ranger                        # Terminal file manager
  rnix-lsp                      # Nix language server
  rust-analyzer
  # stack broken
  starship

  tig                           # Awesome Text based git
  tree
  watson                        # Track your time spent on projects
  wget

  # vim plugin dependencies
  fzf
  ripgrep

  unzip

  # so neovim can copy to clipboard
  xclip
] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
  niv
  usbutils

  # for work
  # TODO: Add packages for work

  pre-commit

] ++ pkgs.lib.optionals withGUI [
  # intended to be installed with an X11 or wayland session
  asciidoctor

  brightnessctl
  enlightenment.terminology
  discord
  joplin-desktop
  #(dwarf-fortress-packages.dwarf-fortress-full.override {
  #  dfVersion = "0.47.04";
  #  theme = dwarf-fortress-packages.themes.phoebus;
  #  enableIntro = false;
  #  enableFPS = true;
  #})
  nerdfonts
  #shutter # screenshots
  #flameshot
  slack
  spotify

  tmate

  # for work
  # TODO: Add packages for work
  freerdp

]
