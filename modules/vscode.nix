{config, pkgs, ...}:
let
  hasGUI = config.wayland.enable || config.xorg.enable;
{
  programs.vscode = {
    enable = hasGUI;
    package = pkgs.vscode-fhsWithPackages (pkgs: with pkgs; [ zlib rustup ]);
    extensions = with pkgs.vscode-extensions; [
      asciidoctor.asciidoctor-vscode
      vscodevim.vim
      ms-python.python
      # TODO: Add Codal extension with fetchURL
    ];
  };
}