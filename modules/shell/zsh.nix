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

      function sync_files_to_cruncher () {
        local OBILIX_PATH=$(git rev-parse --show-toplevel)
        local OBILIX_BASENAME=$(basename $OBILIX_PATH)
	      local PATH_REL_TO_OBILIX=$(realpath --relative-to=$OBILIX_PATH $1)
	      local CRUNCH_OBILIX_PATH=/home/cristian.bourceanu/centoslinux_home/$OBILIX_BASENAME
	      local CRUNCH_FILE_PATH=$CRUNCH_OBILIX_PATH/$PATH_REL_TO_OBILIX
	      echo "Syncronize $PATH_REL_TO_OBILIX to cruncher machine"
	      if [[ -d $1 ]]
	      then
	        rsync --progress -r -L $1/ $CRUNCH:$CRUNCH_FILE_PATH
	      else
	        rsync --progress $1 $CRUNCH:$CRUNCH_FILE_PATH
	      fi
	    }

	    function sync_files_from_cruncher () {
        local OBILIX_PATH=$(git rev-parse --show-toplevel)
        local OBILIX_BASENAME=$(basename $OBILIX_PATH)
	      local PATH_REL_TO_OBILIX=$(realpath --relative-to=$OBILIX_PATH $1)
	      local CRUNCH_OBILIX_PATH=/home/cristian.bourceanu/centoslinux_home/$OBILIX_BASENAME
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

      function match_crunch_path () {
        local match_path='s/\/home\/cristian.bourceanu\/obilix/'
        local path_escape_delimiter=$(echo $OBILIX_PATH | awk '{gsub("/","\\/");}1')
        local sed_regex_replace=$match_path$path_escape_delimiter"/g"
        local files=$(find $1 -type f)

        # FIXME There must be an easier way to read one line at a time
        while IFS= read -r file;
        do
          sed -i $sed_regex_replace $file
        done <<< $files
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
      match_crunch_path="match_crunch_path $1";
      docs_lint="open /mnt/edatools/software/linux/synopsys/vc_static/T-2022.06-SP2-1/doc/vcst/VC_SpyGlass_Docs/PDFs/VC_SpyGlass_Lint_UserGuide.pdf";
      docs_syn="open /mnt/edatools/software/linux/cadence/ddi_22.30/GENUS221/docs/genus_timing/genus_timing.pdf";
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
    #export PATH=/opt/mentor/questasim/linux_x87_65:$PATH
    #export PATH=/root/.local/bin:$PATH
    #
    #export ONESPINROOT=/opt/onespin/2022.4.1
    #export PATH="$PATH":"$ONESPINROOT"/bin

    #export PATH=$HOME/.cargo/bin:$PATH
    export PATH="/home/cristi/.local/bin:$PATH"

    export OBILIX_PATH=$HOME/Documents/Scripts/A71/obilix
    export CRUNCH=cristian.bourceanu@app-team-cruncher.user.codasip.com
  '';

}
