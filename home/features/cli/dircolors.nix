{ pkgs, ... }:
{
  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = __readFile (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/trapd00r/LS_COLORS/bcf78f74be4788ef224eadc7376ca780ae741e1e/LS_COLORS";
        hash = "sha256-itKCWFPpJcTbw25DZCY7dktZh7/hU9RLHCmRLXvksno=";
      });
  };
}
