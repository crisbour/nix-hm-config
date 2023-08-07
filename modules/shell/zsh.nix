{ config, pkgs, lib, ... }: {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
    #defaultKeymap = "viins"; #vicmd or viins

    sessionVariables = {
      COLORTERM = "truecolor";
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";

    };

    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true; # ignore commands starting with a space
      extended = true;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 50000;
      size = 50000;
      share = true;
    };

    plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      #{
      #  name = "forgit";
      #  file = "forgit.plugin.zsh";
      #  src = "${pkgs.forgit}/share/forgit";
      #}
    ];

    initExtra = ''
      # fixes starship swallowing newlines
      precmd() {
        precmd() {
          echo
        }
      }
	export OBILIX_PATH=$HOME/Documents/Scripts/A71/obilix
	export CRUNCH=cristian.bourceanu@app-team-cruncher.user.codasip.com

      # needed for gardenctl
      if [ -z "$GCTL_SESSION_ID" ] && [ -z "$TERM_SESSION_ID" ]; then
        export GCTL_SESSION_ID=$(uuidgen)
      fi

      # TODO: handle secrets somehow
      #source /secrets/environment.bash

      bindkey '^e' edit-command-line
      # this is backspace
      bindkey '^H' autosuggest-accept
      bindkey '^ ' autosuggest-accept

      bindkey '^k' up-line-or-search
      bindkey '^j' down-line-or-search

      bindkey '^r' fzf-history-widget
      bindkey '^f' fzf-file-widget

      function cd() {
        builtin cd $*
        lsd
      }

      function mkd() {
        mkdir $1
        builtin cd $1
      }

      function take() { builtin cd $(mktemp -d) }
      function vit() { nvim $(mktemp) }

      function lgc() { git commit --signoff -m "$*" }

      function clone() { git clone git@$1.git }

      function gclone() { clone github.com:$1 }

      function bclone() { gclone breuerfelix/$1 }

      function gsm() { git submodule foreach "$* || :" }

      function gitdel() {
        git tag -d $1
        git push --delete origin $1
      }

      function lg() {
        git add --all
        git commit --signoff -a -m "$*"
        git push
      }

      function dci() { docker inspect $(docker-compose ps -q $1) }

      function transfer() {
        wget --method PUT --body-file=$1 https://up.fbr.ai/$1 -O - -nv
      }

      function nf() {
        pushd ~/.nixpkgs
        nix --experimental-features "nix-command flakes" build ".#darwinConfigurations.alucard.system"
        ./result/sw/bin/darwin-rebuild switch --flake ~/.nixpkgs
      }

      function nfh() {
        pushd ~/.config/nixpkgs
        nix --experimental-features "nix-command flakes" build ".#homeConfigurations.solid.activationPackage"
        ./result/activate
      }

      function nfs() {
        pushd ~/.config/nixpkgs
        sudo nixos-rebuild switch --flake ".#rocky"
      }

	function sync_files_to_cruncher () {
	  local PATH_REL_TO_OBILIX=$(realpath --relative-to=$OBILIX_PATH $1)
	  echo "Syncronize $PATH_REL_TO_OBILIX to cruncher machine"
	  if [[ -d $1 ]]
	  then
	    rsync --progress -r -L $1/ -a $CRUNCH:~/centoslinux_home/obilix/$PATH_REL_TO_OBILIX
	  else
	    rsync --progress $1 $CRUNCH:~/centoslinux_home/obilix/$PATH_REL_TO_OBILIX
	  fi
	}
	
	function sync_files_from_cruncher () {
	  set -x
	  local PATH_REL_TO_OBILIX=$(realpath --relative-to=$OBILIX_PATH $1)
	  local CRUNCH_OBILIX_PATH=/home/cristian.bourceanu/centoslinux_home/obilix
	  local CRUNCH_FILE_PATH=$CRUNCH_OBILIX_PATH/$PATH_REL_TO_OBILIX
	  echo "Syncronize $PATH_REL_TO_OBILIX from cruncher machine"
	  local file_type=$(ssh $CRUNCH "file -b $CRUNCH_FILE_PATH")
	  echo "File type to sync from cruncher: $file_type"
	  if [[ $file_type == *directory* ]];
	  then
	    rsync --progress -r $CRUNCH:$CRUNCH_FILE_PATH/ $1
	  else
	    rsync --progress $CRUNCH:$CRUNCH_FILE_PATH $1
	  fi
	
	}
    '';

    dirHashes = {
      dl = "$HOME/Downloads";
      nix = "$HOME/.nixpkgs";
      code = "$HOME/code";
    };

    shellAliases = {
      # builtins
      size = "du -sh";
      cp = "cp -i";
      mkdir = "mkdir -p";
      df = "df -h";
      free = "free -h";
      du = "du -sh";
      susu = "sudo su";
      op = "xdg-open";
      del = "rm -rf";
      sdel = "sudo rm -rf";
      lst = "ls --tree -I .git";
      lsl = "ls -l";
      lsa = "ls -a";
      null = "/dev/null";
      tmux = "tmux -u";
      tu = "tmux -u";
      tua = "tmux a -t";

      # overrides
      cat = "bat";
      #ssh = "TERM=screen ssh";
      python = "python3";
      pip = "python3 -m pip";
      venv = "python3 -m venv";
      j = "z";

      # programs
      g = "git";
      dk = "docker";
      pd = "podman";
      pc = "podman-compose";
      sc = "sudo systemctl";
      poe = "poetry";
      fb = "pcmanfm .";
      space = "ncdu";
      ca = "cargo";
      diff = "delta";
      py = "python";
      awake = "caffeinate";
      # TODO What are the followings?
      os = "openstack";
      pu = "pulumi";

      # TODO make myself a terminal cheatsheet
      # terminal cheat sheet
      cht = "cht.sh";

      # utilities
      psf = "ps -aux | grep";
      lsf = "ls | grep";
      shut = "sudo shutdown -h now";
      tssh = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      socks = "ssh -D 1337 -q -C -N";

      # clean
      dklocal = "docker run --rm -it -v `PWD`:/usr/workdir --workdir=/usr/workdir";
      dkclean = "docker container rm $(docker container ls -aq)";

      caps = "xdotool key Caps_Lock";
      gclean = "git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done";
      ew = "nvim -c ':cd ~/vimwiki' ~/vimwiki";
      weather = "curl -4 http://wttr.in/Koeln";

      # nix
      ne = "nvim -c ':cd ~/.nixpkgs' ~/.nixpkgs";
      clean = "nix-collect-garbage -d && nix-store --gc && nix-store --verify --check-contents --repair";
      nsh = "nix-shell";
      nse = "nix search nixpkgs";

      # Work
      codasip-vpn="sudo openvpn --config /etc/openvpn/client.conf";
      mount-nfs="find /samba/ -maxdepth 1 -not -path /samba/ -type d | for i in $(cat); do sudo mount $i; done";
      sync_to_cruncher="sync_files_to_cruncher $1";
      sync_from_cruncher="sync_files_from_cruncher $1";
	docs_lint="open /mnt/edatools/software/linux/synopsys/vc_static/T-2022.06-SP2-1/doc/vcst/VC_SpyGlass_Docs/PDFs/VC_SpyGlass_Lint_UserGuide.pdf";
	docs_syn="open /mnt/edatools/software/linux/cadence/ddi_22.30/GENUS221/docs/genus_timing/genus_timing.pdf";
    };

    prezto = {
      enable = true;
      caseSensitive = false;
      utility.safeOps = true;
      editor = {
        dotExpansion = true;
        keymap = "vi";
      };
      pmodules = [
        "autosuggestions"
        "completion"
        "directory"
        "editor"
        "git"
        "terminal"
      ];
    };

  profileExtra = ''

	# Environmental Variables
	export LM_LICENSE_FILE="$LM_LICENSE_FILE":"27200@licenses.codasip.com"
	export LM_LICENSE_FILE="1717@licenses.codasip.com:$LM_LICENSE_FILE"
	#export LMX_LICENSE_PATH="license-server.codasip.com%6200:licenses.codasip.com%6200"
	export LMX_LICENSE_PATH=codasip3%6200:license-server.codasip.com%6200
	
	# Tools
	#export PATH=/opt/mentor/questasim/linux_x87_65:$PATH
	#export PATH=/root/.local/bin:$PATH
	#
	#export ONESPINROOT=/opt/onespin/2022.4.1
	#export PATH="$PATH":"$ONESPINROOT"/bin
	
	#export PATH=$HOME/.cargo/bin:$PATH
	export PATH="/home/cristi/.local/bin:$PATH"

  '';

}
