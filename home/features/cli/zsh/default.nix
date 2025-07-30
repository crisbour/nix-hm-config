{ config, pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
    #defaultKeymap = "viins"; #vicmd or viins


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
          name = "powerlevel10k";
          src  = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src  = lib.cleanSource ./config;
          file = "p10k.zsh";
        }

        #{
        #  name = "zsh-syntax-highlighting";
        #  src = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
        #  file = "nix-syntax-highlighting.plugin.zsh";
        #}
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma-continuum";
            repo = "fast-syntax-highlighting";
            rev = "v1.55";
            sha256 = "sha256-DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
          };
        }

        {
          name = "zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "0.35.0";
            sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
          };
        }

        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "v1.1.0";
            sha256 = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
          };
        }

        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src  = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      # #https://github.com/kalbasit/shabka/blob/master/modules/home/software/zsh/default.nix
        #{
        #  name = "enhancd";
        #  file = "init.sh";
        #  src = pkgs.fetchFromGitHub {
        #    owner = "b4b4r07";
        #    repo = "enhancd";
        #    rev = "v2.5.1";
        #    sha256 = "sha256-kaintLXSfLH7zdLtcoZfVNobCJCap0S/Ldq85wd3krI=";
        #  };
        #}

        # colored-man-pages extracted from oh-my-zsh
        # TODO: Debug
        {
          name = "colored-man-pages";
          src = pkgs.fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "48ccc7b36de8efb2bd7beb9bd6e0a6f6fe03b95d";
            sha256 = "sha256-OZc6FxmfQoFfEd589g4f022F6CUHQyEWwV/Ka0HCGag=";
          };
          file="plugins/colored-man-pages/colored-man-pages.plugin.zsh";
        }

        {
          name = "forgit";
          src = pkgs.fetchFromGitHub {
            owner = "wfxr";
            repo = "forgit";
            rev = "23.09.0";
            sha256 = "sha256-WvJxjEzF3vi+YPVSH3QdDyp3oxNypMoB71TAJ7D8hOQ=";
          };
        }
    ];

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
      ls    = "eza";
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
      sc    = "sudo systemctl";
      poe   = "poetry";
      fb    = "pcmanfm .";
      space = "ncdu";
      ca    = "cargo";
      diff  = "delta";
      py    = "python";

      # TODO make myself a terminal cheatsheet
      # terminal cheat sheet
      cht = "cht.sh";

      # utilities
      psf     = "ps -aux | grep";
      lsf     = "eza | grep";
      shut    = "sudo shutdown -h now";
      tssh    = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      socks   = "ssh -D 1337 -q -C -N";

      # clean
      dklocal = "docker run --rm -it -v `PWD`:/usr/workdir --workdir=/usr/workdir";
      dkclean = "docker container rm $(docker container ls -aq)";

      caps    = "xdotool key Caps_Lock";
      gclean  = "git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done";
      weather = "curl -4 http://wttr.in/Cambridge";

      # nix
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

    initContent = ''
      export DATASTORE_3D_PATH=/mnt/datastore-3D
      export DATASTORE_PATH=/mnt/datastore

      # needed for gardenctl
      if [ -z "$GCTL_SESSION_ID" ] && [ -z "$TERM_SESSION_ID" ]; then
        export GCTL_SESSION_ID=$(uuidgen)
      fi

      # TODO: handle secrets somehow
      #source /secrets/environment.bash

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

    profileExtra = ''
      export DATASTORE_3D_PATH=/mnt/datastore-3D
      export DATASTORE_PATH=/mnt/datastore

      #export PATH=$HOME/.cargo/bin:$PATH
      export PATH=$HOME/.local/bin:$PATH
      export PATH=$HOME/Software/tabby/bin:$PATH
      export YOSYSHQ_LICENSE=$HOME/Software/tabby/tabbycad-eval-CristianBourceanu-250518.lic

      # TODO Fix loading dev packages
      #export JULIA_LOAD_PATH=/home/cristi/.julia/dev
    '';
  };

}
