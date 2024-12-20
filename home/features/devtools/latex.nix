{ pkgs, ... }:
{
  home.packages = [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
      scheme-medium # base
      amsmath # math symbols
      biblatex
      paper
      subfigure
      caption
      latexmk
      collection-latex
      lkproof # proof
      preprint # for fullpage.sty
      moreverb
      # NOTE: Search packages named base on required style file at https://ctan.org/ (Comprehensive TEX Archive Network)
      ;
    })
  ];
}

#pkgs.texlive.combine {
#  inherit (pkgs.texlive)
#    scheme-medium # base
#    amsmath # math symbols
#    beamer # beamer
#    biblatex # citations
#    capt-of
#    catchfile
#    cm-super # vectorized fonts
#    collection-latex # pdflatex
#    csquotes
#    dvipng
#    framed
#    fvextra
#    latexmk
#    lkproof # proof rules
#    minted # source code
#    float # minted depends on float
#    preprint
#    rotfloat
#    ulem
#    upquote
#    wrapfig
#    xstring
#    endnotes
#    caption
#    subfigure # nested figures
#    biber
#    parskip
#    enumitem
#    # Paper stuff
#    paper
#    fancyvrb
#    lineno
#    algpseudocodex
#    algorithms
#    algorithmicx
#    koma-script
#    xpatch # needed for thesis
#    # new environments
#    environ
#    filecontents
#    # PL
#    semantic
#    # quantum
#    braket
#    qcircuit
#    xypic
#  ;
#}
