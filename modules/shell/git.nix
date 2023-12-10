{ config, pkgs, lib, ... }: {
    enable = true;
    userName = "Cristi Bourceanu";
    userEmail = "bourceanu.cristi@gmail.com";
    signing = {
      key="A6307A244F3BD76D";
      signByDefault = true;
    };
    aliases = {
      cm = "commit";
      ca = "commit --amend --no-edit";
      di = "diff";
      dh = "diff HEAD";
      pu = "pull";
      ps = "push";
      pf = "push --force-with-lease";
      s  = "status -sb";
      co = "checkout";
      cb = "checkout -b";
      fe = "fetch";
      gr = "grep -in";
      re = "rebase -i";
      cp = "cherry-pick";
      sur = "submodule update --init --recursive";
    };

    delta = {
      enable = true;
      options = {
        theme = "OneHalfDark";
        #side-by-side = true;
        line-numbers = true;
      };
    };

    extraConfig = {
      github.user = "crisbour";
      url."git@github.com:crisbour/" = {
        insteadOf = [
          "me:"
          "https://github.com/crisbour/"
        ];
      };
      url."ssh://git@github.com" = {
        insteadOf = "https://github.com";
      };

      init.defaultBranch = "main";

      pull = {
        ff = false;
        commit = false;
        rebase = true;
      };
      push = {
        default = "upstream";
        autoSetupRemote = true;
      };

      commit.gpgsign = "true";
      #gpg.format = "ssh";

      #protocol.keybase.allow = "always";
      #credentials.helper = "cache";

    };
    ignores = [
      "build" # build directory
      ".idea" ".vs" ".vsc" ".vscode" # ide
      "__pycache__" "*.pyc" # python
    ];

}
