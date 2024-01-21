{ pkgs, ...}:
let
  terminal = "${pkgs.alacritty}/bin/alacritty";
  editor = "nvim";
in
{
  imports = [
    ./alacritty
    ./zellij
    ./bash.nix
    ./browser.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./neovim
    ./nix.nix
    ./ssh.nix
    ./vscode.nix
    ./xdg.nix
    # TODO Separate fields in zsh to make it easier to read and navigate
    ./zsh
    # TODO Configure with my own interests
    ./newsboat.nix

    ./devtools.nix

    #./yubikey.nix

    #./calendar

    #./communication.nix
    # Not sure I need this
    #./syncthing.nix
  ];

  home.sessionVariables = {
    COLORTERM = "truecolor";
    VISUAL    = "${editor}";
    EDITOR    = "${editor}";
    SHELL     = "${pkgs.zsh}/bin/zsh";
    TERMINAL  = "${terminal}";
    #SSH_AUTH_SOCK = lib.mkForce "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
}

