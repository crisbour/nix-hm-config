{ pkgs, ... }:
let
  inherit (pkgs) stdenv fetchFromGitLab writeText vim vimUtils;
in
vimUtils.buildVimPlugin rec {
  version = "v0.1";
  #versionSuffix = "pre${toString src.revCount or 0}.${src.shortRev or "0000000"}";
  pname = "vim-codal-${version}";
  src = ./.;
  meta = with pkgs.lib; {
    description = "Codal Vim Syntax Highlighting Plugin";
  };
}
