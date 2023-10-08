{ pkgs, config, lib}: withGUI:
let
  bashsettings = import ./modules/bash.nix pkgs;
  vimsettings = import ./modules/vim.nix;
  gitsettings = (import ./modules/shell/git.nix) {inherit config pkgs lib;};
  zshsettings = (import ./modules/shell/zsh.nix) { inherit config pkgs lib; };
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux;
in
{
  alacritty = (import ./modules/alacritty/alacritty.nix) {
    inherit config;
    inherit lib;
    inherit pkgs;
  } withGUI;

  bash = bashsettings;
  neovim = vimsettings pkgs;

  # Why do we use both packages and versions of direnv
  #direnv= {
  #  enable = true;
  #  enableZshIntegration = true;

  #  stdlib = ''
  #    use_riff() {
  #      watch_file Cargo.toml
  #      watch_file Cargo.lock
  #      eval "$(riff print-dev-env)"
  #      }
  #    '';
  #  nix-direnv.enable = true;
  #};

  dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  git = gitsettings;

  gpg = {
    enable = true;
    settings = {
      default-key = "2CE17E1BCFECF3D6";
      no-comments = false;
      # Get rid of the copyright notice
      no-greeting = true;
      # Because some mailers change lines starting with "From " to ">From "
      # it is good to handle such lines in a special way when creating
      # cleartext signatures; all other PGP versions do it this way too.
      no-escape-from-lines = true;
      # Use a modern charset
      charset = "utf-8";
      ### Show keys settings
      # Always show long keyid
      keyid-format = "0xlong";
      # Always show the fingerprint
      with-fingerprint = true;
    };
  };

  # Let Home Manager install and manage itself.
  home-manager.enable = true;

  htop = {
    enable = true;
    settings = {
      left_meters = [ "LeftCPUs2" "Memory" "Swap" ];
      left_right = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
      setshowProgramPath = false;
      treeView = true;
    };
  };

  ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
			slurmlogin1 = {
  			hostname = "in-czba-psl0001.slurm.codasip.com";
  			user = "cristian.bourceanu";
  			extraOptions = {
					GSSAPIDelegateCredentials = "yes";
				};
			};

			slurmlogin2 = {
  			hostname = "in-czba-psl0002.slurm.codasip.com";
  			user = "cristian.bourceanu";
  			extraOptions = {
					GSSAPIDelegateCredentials = "yes";
				};
			};
		};
	};

  vscode = mkIf withGUI {
    enable = true;
    package = pkgs.vscode-fhsWithPackages (pkgs: with pkgs; [ zlib rustup ]);
    extensions = with pkgs.vscode-extensions; [
      asciidoctor.asciidoctor-vscode
      vscodevim.vim
      ms-python.python
    ];
  };

  # Terminal workspace more powerfull than tmux
  zellij = {
    enable = true;
    settings = { };
  };

  # Better cd
  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  zsh = zshsettings;

}
