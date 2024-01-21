final: prev:

let
  nixGLWrap = wrapper: pkg:
    prev.runCommand "${pkg.name}-nixgl-wrapper" { } ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
       wrapped_bin=$out/bin/$(basename $bin)
       echo "exec ${prev.lib.getExe wrapper} $bin \$@" > $wrapped_bin
       chmod +x $wrapped_bin
      done
    '';
in {
#  alacritty      = nixGLWrap prev.nixgl.auto.nixGLDefault prev.alacritty;
  joplin-desktop = nixGLWrap prev.nixgl.auto.nixGLDefault prev.joplin-desktop;
  # FIXME:  error: attribute 'fhsWithPackages' missing
  #vscode       = nixGLWrap prev.nixgl.auto.nixGLDefault prev.vscode;
  spotify        = nixGLWrap prev.nixgl.auto.nixGLDefault prev.spotify;
}
