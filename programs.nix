{ pkgs, config, lib}: withGUI:
let
  bashsettings = import ./modules/bash.nix pkgs;
  vimsettings = import ./modules/vim/vim.nix;
  gitsettings = (import ./modules/shell/git.nix) {inherit config pkgs lib;};
  zshsettings = (import ./modules/shell/zsh) { inherit config pkgs lib; };
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

  browserpass = {
    enable = true;
    browsers = [
      "brave"
    ];
  };

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
    extraConfig = __readFile (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/trapd00r/LS_COLORS/bcf78f74be4788ef224eadc7376ca780ae741e1e/LS_COLORS";
        hash = "sha256-itKCWFPpJcTbw25DZCY7dktZh7/hU9RLHCmRLXvksno=";
      });
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  git = gitsettings;

  gpg = {
    enable = true;
    settings = {
      default-key = "0x152B728E9A90E3ED";
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
    scdaemonSettings = {
      disable-ccid = true;
      pcsc-shared = true;
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

  neovim = vimsettings pkgs;

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

			vdilogin = {
  			hostname = "10.13.72.10";
  			user = "cristian.bourceanu";
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
