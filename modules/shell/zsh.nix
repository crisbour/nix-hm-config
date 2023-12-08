{ config, pkgs, lib, ... }: {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
    #defaultKeymap = "viins"; #vicmd or viins

    sessionVariables = {
      #COLORTERM = "truecolor";
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
      #{
      #  name = "fast-syntax-highlighting";
      #  file = "fast-syntax-highlighting.plugin.zsh";
      #  src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      #}
      #{
      #  name = "zsh-nix-shell";
      #  file = "nix-shell.plugin.zsh";
      #  src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      #}
      # https://github.com/kalbasit/shabka/blob/master/modules/home/software/zsh/default.nix
        {
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "fd805158ea19d640f8e7713230532bc95d379ddc";
            sha256 = "0pc19dkp5qah2iv92pzrgfygq83vjq1i26ny97p8dw6hfgpyg04l";
          };
        }

        {
          name = "gitit";
          src = pkgs.fetchFromGitHub {
            owner = "peterhurford";
            repo = "git-it-on.zsh";
            rev = "4827030e1ead6124e3e7c575c0dd375a9c6081a2";
            sha256 = "01xsqhygbxmv38vwfzvs7b16iq130d2r917a5dnx8l4aijx282j2";
          };
        }

        {
          name = "solarized-man";
          src = pkgs.fetchFromGitHub {
            owner = "zlsun";
            repo = "solarized-man";
            rev = "a902b64696271efee95f37d45589078fdfbbddc5";
            sha256 = "04gm4qm17s49s6h9klbifgilxv8i45sz3rg521dwm599gl3fgmnv";
          };
        }

        {
          name = "powerlevel9k";
          file = "powerlevel9k.zsh-theme";
          src = pkgs.fetchFromGitHub {
            owner = "bhilburn";
            repo = "powerlevel9k";
            rev = "571a859413866897cf962396f02f65a288f677ac";
            sha256 = "0xwa1v3c4p3cbr9bm7cnsjqvddvmicy9p16jp0jnjdivr6y9s8ax";
          };
        }

        {
          name = "zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "0.27.0";
            sha256 = "1c2xx9bkkvyy0c6aq9vv3fjw7snlm0m5bjygfk5391qgjpvchd29";
          };
        }

        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "47a7d416c652a109f6e8856081abc042b50125f4";
            sha256 = "1mvilqivq0qlsvx2rqn6xkxyf9yf4wj8r85qrxizkf0biyzyy4hl";
          };
        }

        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "db6cac391bee957c20ff3175b2f03c4817253e60";
            sha256 = "0d9nf3aljqmpz2kjarsrb5nv4rjy8jnrkqdlalwm2299jklbsnmw";
          };
        }

        {
          name = "nix-shell";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "03a1487655c96a17c00e8c81efdd8555829715f8";
            sha256 = "1avnmkjh0zh6wmm87njprna1zy4fb7cpzcp8q7y03nw3aq22q4ms";
          };
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

      function dci() { docker inspect $(docker-compose ps -q $1) }

      function nfh() {
        pushd ~/.config/nixpkgs
        nix --experimental-features "nix-command flakes" build ".#homeConfigurations.solid.activationPackage"
        ./result/activate
      }

      function nfs() {
        pushd ~/.config/nixpkgs
        sudo nixos-rebuild switch --flake ".#rocky"
      }

      # args:
      # $1: server as <server> address i.e. user@ip
      # $2: top_path as absolute <top_path> where repositories are
      # $3: path as relative or absolute path
      function sync_files_to_server() {
        local OBILIX_PATH=$(git rev-parse --show-toplevel)
        local SERVER_ADDR=$1
        local SERVER_TOP_PATH=$2
        local SYNC_PATH=$3

        echo "sync_files_to_server($1, $2, $3)"

        local OBILIX_PATH=$(git rev-parse --show-toplevel)
        local OBILIX_BASENAME=$(basename $OBILIX_PATH)
        echo $OBILIX_PATH
	      local PATH_REL_TO_OBILIX=$(realpath --relative-to=$OBILIX_PATH $SYNC_PATH)

	      local SERVER_OBILIX_PATH=$SERVER_TOP_PATH/$OBILIX_BASENAME
	      local SERVER_FILE_PATH=$SERVER_OBILIX_PATH/$PATH_REL_TO_OBILIX
        local SIZE=$(du -h -d 0 $SYNC_PATH)
	      echo "Syncronize $PATH_REL_TO_OBILIX to server machine $SERVER_ADDR: $SIZE"

	      if [[ -d $SYNC_PATH ]]
	      then
	        rsync --progress -r -z -l $SYNC_PATH/ $SERVER_ADDR:$SERVER_FILE_PATH
	      else
	        rsync --progress -l $SYNC_PATH $SERVER_ADDR:$SERVER_FILE_PATH
	      fi
	    }

	    function sync_files_from_server() {
        local SERVER_ADDR=$1
        local SERVER_TOP_PATH=$2
        local SYNC_PATH=$3

        local OBILIX_PATH=$(git rev-parse --show-toplevel)
        local OBILIX_BASENAME=$(basename $OBILIX_PATH)
	      local PATH_REL_TO_OBILIX=$(realpath --relative-to=$OBILIX_PATH .)/$SYNC_PATH

	      local SERVER_OBILIX_PATH=$SERVER_TOP_PATH/$OBILIX_BASENAME
	      local SERVER_FILE_PATH=$SERVER_OBILIX_PATH/$PATH_REL_TO_OBILIX
        local SIZE=$(ssh $SERVER_ADDR "du -h -d 0 $SERVER_FILE_PATH")
	      echo "Syncronize $PATH_REL_TO_OBILIX from cruncher machine $SERVER_ADDR: $SIZE"

	      local file_type=$(ssh $SERVER_ADDR "file -b $SERVER_FILE_PATH")
	      echo "File type to sync from cruncher: $file_type"
	      if [[ $file_type == *directory* ]];
	      then
          if [[ -d $SYNC_PATH ]]; then
            mkdir -p $SYNC_PATH
          fi
	        rsync --progress -r -l -z $SERVER_ADDR:$SERVER_FILE_PATH/ $SYNC_PATH
	      else
	        rsync --progress -l $SERVER_ADDR:$SERVER_FILE_PATH $SYNC_PATH
	      fi

	    }

      function match_server_path () {
        local SERVER_HOME_PATH=$1
        local TREE_TO_MATCH=$2

        local local_top_path=$(git rev-parse --show-toplevel)
        local top_basename=$(basename $local_top_path)
        local server_top_path=$SERVER_HOME_PATH/$top_basename
        local path_match=$(echo $server_top_path | awk '{gsub("/","\\/");}1')
        local path_replace=$(echo $local_top_path | awk '{gsub("/","\\/");}1')
        local sed_regex_replace="s/"$path_match/$path_replace"/g"
        local files=$(find $TREE_TO_MATCH -type f)

        # FIXME There must be an easier way to read one line at a time
        while IFS= read -r file;
        do
          local_file_type=$(file -b --mime-encoding -- $file)
          if [ $local_file_type != binary ]; then
            sed -i $sed_regex_replace $file
          else
            echo "Skip binary file: \t $file"
          fi
          #echo $sed_regex_replace
        done <<< $files
      }

      function crunch_top_path() {
        local local_top_path=$(git rev-parse --show-toplevel)
        local top_basename=$(basename $local_top_path)
        local path=/home/$USER/$top_basename
        echo $path
      }

      function slurm_top_path() {
        local local_top_path=$(git rev-parse --show-toplevel)
        local top_basename=$(basename $local_top_path)
        local path=/home/codasip.com/$USER/$top_basename
        echo $path
      }

      function local_top_path() {
        local path=$(git rev-parse --show-toplevel)
        echo $path
      }

      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';

    dirHashes = {
      dl = "$HOME/Downloads";
      nix = "$HOME/.nixpkgs";
      code = "$HOME/code";
    };

    shellAliases = {
      # builtins
      size  = "du -sh";
      cp    = "cp -i";
      mkdir = "mkdir -p";
      df    = "df -h";
      free  = "free -h";
      du    = "du -sh";
      susu  = "sudo su";
      op    = "xdg-open";
      del   = "rm -rf";
      sdel  = "sudo rm -rf";
      lst   = "ls --tree -I .git";
      lsl   = "ls -l";
      lsa   = "ls -a";
      null  = "/dev/null";
      tmux  = "tmux -u";
      tu    = "tmux -u";
      tua   = "tmux a -t";

      # overrides
      cat    = "bat";
      #ssh = "TERM=screen ssh";
      python = "python3";
      pip    = "python3 -m pip";
      venv   = "python3 -m venv";
      j      = "z";

      # programs
      g     = "git";
      dk    = "docker";
      pd    = "podman";
      pc    = "podman-compose";
      sc    = "sudo systemctl";
      poe   = "poetry";
      fb    = "pcmanfm .";
      space = "ncdu";
      ca    = "cargo";
      diff  = "delta";
      py    = "python";
      awake = "caffeinate";
      # TODO What are the followings?
      os    = "openstack";
      pu    = "pulumi";

      # TODO make myself a terminal cheatsheet
      # terminal cheat sheet
      cht = "cht.sh";

      # utilities
      psf     = "ps -aux | grep";
      lsf     = "ls | grep";
      shut    = "sudo shutdown -h now";
      tssh    = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      socks   = "ssh -D 1337 -q -C -N";

      # clean
      dklocal = "docker run --rm -it -v `PWD`:/usr/workdir --workdir=/usr/workdir";
      dkclean = "docker container rm $(docker container ls -aq)";

      caps    = "xdotool key Caps_Lock";
      gclean  = "git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done";
      ew      = "nvim -c ':cd ~/vimwiki' ~/vimwiki";
      weather = "curl -4 http://wttr.in/Koeln";

      # nix
      ne    = "nvim -c ':cd ~/.nixpkgs' ~/.nixpkgs";
      clean = "nix-collect-garbage -d && nix-store --gc && nix-store --verify --check-contents --repair";
      nsh   = "nix-shell";
      nse   = "nix search nixpkgs";

      # Work
      codasip-vpn        = "sudo openvpn --config /etc/openvpn/client.conf";
      mount-nfs          = "find /samba/ -maxdepth 1 -not -path /samba/ -type d | for i in $(cat); do sudo mount $i; done";
      sync_to_cruncher   = "sync_files_to_server $CRUNCH /home/$USER/centoslinux_home $1";
      sync_from_cruncher = "sync_files_from_server $CRUNCH /home/$USER/centoslinux_home $1";
      sync_to_slurm      = "sync_files_to_server slurmlogin1 /home/codasip.com/$USER $1";
      sync_from_slurm    = "sync_files_from_server slurmlogin1 /home/codasip.com/$USER $1";
      match_crunch_path  = "match_server_path /home/$USER $1";
      match_slurm_path   = "match_server_path $HOME $1";
      docs_lint          = "open /mnt/edatools/software/linux/synopsys/vc_static/T-2022.06-SP2-1/doc/vcst/VC_SpyGlass_Docs/PDFs/VC_SpyGlass_Lint_UserGuide.pdf";
      docs_syn           = "open /mnt/edatools/software/linux/cadence/ddi_22.30/GENUS221/docs/genus_timing/genus_timing.pdf";
      vis-cruncher       = "vis +change_file_path+$(crunch_top_path)=$(local_top_path) $@";
      vis-slurm          = "vis +change_file_path+$(slurm_top_path)=$(local_top_path) $@";
    };

    #prezto = {
    #  enable = true;
    #  caseSensitive = false;
    #  utility.safeOps = true;
    #  editor = {
    #    dotExpansion = true;
    #    keymap = "vi";
    #  };
    #  pmodules = [
    #    "autosuggestions"
    #    "completion"
    #    "directory"
    #    "editor"
    #    "git"
    #    "terminal"
    #  ];
    #};

  profileExtra = ''

    # Environmental Variables
    export LM_LICENSE_FILE="$LM_LICENSE_FILE":"27200@licenses.codasip.com"
    export LM_LICENSE_FILE="1717@licenses.codasip.com:$LM_LICENSE_FILE"
    #export LMX_LICENSE_PATH="license-server.codasip.com%6200:licenses.codasip.com%6200"
    export LMX_LICENSE_PATH=codasip3%6200:license-server.codasip.com%6200

    # Tools
    export PATH=$PATH:/opt/Mentor/questasim_2023.2/questasim/bin
    export PATH=$PATH:/opt/codasip/studio-10.0.0-748/bin
    #export PATH=/root/.local/bin:$PATH
    #
    #export ONESPINROOT=/opt/onespin/2022.4.1
    #export PATH="$PATH":"$ONESPINROOT"/bin

    #export PATH=$HOME/.cargo/bin:$PATH
    export PATH=$HOME/.local/bin:$PATH

    export OBILIX_PATH=$HOME/Documents/Scripts/A71/obilix
    export CRUNCH=cristian.bourceanu@app-team-cruncher.user.codasip.com
  '';

}
