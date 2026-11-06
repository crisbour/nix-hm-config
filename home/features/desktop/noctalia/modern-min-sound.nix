{ pkgs, ... }:
let
  modern-minimal-sound = pkgs.stdenvNoCC.mkDerivation {
    pname = "modern-minimal-sound";
    version = "1.2.0";
    src = pkgs.fetchFromGitHub {
      owner = "cadecomposer";
      repo = "modern-minimal-ui-sounds";
      rev = "V1.2";
      sha256 = "sha256-l8/nxuzBns2cyhGFral+XrTGSbI6jasoBvowQz72VOI=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sounds/ModernMinimal
      cp -aR $src/stereo $out/share/sounds/ModernMinimal
      cp $src/index.theme $out/share/sounds/ModernMinimal
    '';
  };
in
{
  home.packages = with pkgs; [
    modern-minimal-sound
  ];
}
