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
  pyyaml # YAML
  plotly
  setuptools # setup.py
  tabulate
  (
    buildPythonPackage rec {
      pname = "sortgs";
      version = "1.0.2";
      src = fetchPypi {
        inherit pname version;
        hash = "sha256-XdYo6nwt9Tm2GVvBo/tPQo4pZb633MW3zjvbUqAAcTQ=";
      };
      doCheck = false;
      propagatedBuildInputs = [
        # Specify dependencies
        pandas
      ];
    }
  )
  (
    buildPythonPackage rec {
      pname = "webio_jupyter_extension";
      version = "0.1.0";
      src = fetchPypi {
        inherit pname version;
        hash = "sha256-m0FJa4bdC1c02Z+YeFumjPSzzXWuXHBLl7usvxmO0rc=";
      };
      doCheck = false;
      propagatedBuildInputs = [
        # Specify dependencies
        jupyter-packaging
      ];
    }
  )
])
