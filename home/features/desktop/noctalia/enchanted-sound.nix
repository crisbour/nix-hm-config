{ pkgs, ... }:
let
  noctalia-rtl88-sound-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "noctalia-rtl88-sound-theme";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "rtlewis88";
      repo = "rtl88-Themes";
      rev = "Enchanted-Complete-System-Sounds";
      sha256 = "sha256-zOtaZLXZ+U+ZhQcjSeBy3uM3t+ruoe5udxhN9KwrzuQ=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sounds
      cp -aR $src/Enchanted $out/share/sounds
    '';
  };
in
{
  home.packages = with pkgs; [
    noctalia-rtl88-sound-theme
  ];
}
