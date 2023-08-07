{ pkgs }:

pkgs.python3.withPackages (p: with p; [
  ipython # interactive shell
  #jupyter # interactive notebooks
  matplotlib # plots
  networkx # graphs
  numpy # numerical computation
  pandas # data analysis
  pylint # static checking
  setuptools # setup.py
  pre-commit-hooks
])
