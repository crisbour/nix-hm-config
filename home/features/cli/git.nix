# TODO
# Correct users detection fails in RHEL: https://discourse.nixos.org/t/unable-to-use-nixpkgs-git-on-rhel-7/12598

{ config, pkgs, lib, ... }:
let
  inherit (config.home) user-info;
in
{
  programs.git = {
    enable = true;

    signing = {
      key           = user-info.gpg.signKey;
      signByDefault = !builtins.isNull user-info.gpg.signKey;
    };

    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
        contents = {
          user = {
            name = "Cristi Bourceanu";
            email = "bourceanu.cristi@gmail.com";
          };
        };
      }
      {
        condition = "hasconfig:remote.*.url:git@git.ecdf.ed.ac.uk:*/**";
        contents = {
          user = {
            name = "Cristian Bourceanu";
            email = "v.c.bourceanu@sms.ed.ac.uk";
          };
        };
      }
    ];

    settings = {

      user = {
        name= "Cristi Bourceanu";
        email = "bourceanu.cristi@gmail.com";
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
        lt = "log --graph --oneline --decorate --all";
        lta = "log --graph --oneline --decorate --all --author";
      };

      # ===================
      # extraConfig
      # ===================
      core.editor = "nvim";
      github.user = "crisbour";
      # NOTE: Following is annoying when I am using my own projects as dependencies to packages that call system git
      url."git@github.com:crisbour/" = {
        insteadOf = [
          "me:"
          "https://github.com/crisbour/"
        ];
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

      commit.gpgsign = !builtins.isNull user-info.gpg.signKey;
      #gpg.format = "ssh";

      #protocol.keybase.allow = "always";
      #credentials.helper = "cache";

    };


    ignores = [
      "build" # build directory
      ".idea" ".vs" ".vsc" ".vscode" # ide
      "__pycache__" "*.pyc" ".venv" # python
      ".direnv"
      ".cache"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      theme = "OneHalfDark";
      #side-by-side = true;
      line-numbers = true;
    };
  };

}
