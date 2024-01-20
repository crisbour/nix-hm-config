{ pkgs }:

pkgs.python3.withPackages (p: with p; [
  ipython # interactive shell
  jupyter # interactive notebooks
  matplotlib # plots
  networkx # graphs
  numpy # numerical computation
  pandas # data analysis
  pip
  pre-commit-hooks
  pylint # static checking
  pynvim
  python-gitlab
  python-lsp-black
  python-lsp-server
  setuptools # setup.py
  tabulate
])
