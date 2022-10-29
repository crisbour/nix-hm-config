{
  lib,
  pkgs,
  ...
}:
# Shared configuration for all profiles.
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-ms-vscode-cpptools"
      "vscode-extension-asciidoctor-asciidoctor-vscode"
      "slack"
      "discord"
      "zoom"
      "spotify"
      "spotify-unwrapped"
    ];

  programs.home-manager.enable = true;
}
