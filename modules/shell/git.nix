{ config, pkgs, lib, ... }: {
    enable = true;
    userName = "Cristi Bourceanu";
    userEmail = "bourceanu.cristi@gmail.com";
    signing = {
      key = "89DBB39E67BD4E0EFCB038B62CE17E1BCFECF3D6";
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
      st  = "status -sb";
      co = "checkout";
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
      #gpg.program = "gpg2";

      #protocol.keybase.allow = "always";
      #credentials.helper = "cache";

    };
    ignores = [
      "build" # build directory
      ".idea" ".vs" ".vsc" ".vscode" # ide
      "__pycache__" "*.pyc" # python
    ];

}
