# TODO
# Correct users detection fails in RHEL: https://discourse.nixos.org/t/unable-to-use-nixpkgs-git-on-rhel-7/12598

{ config, pkgs, lib, ... }:
let
  inherit (config.home) user-info;
in
{
  home.packages = with pkgs.gitAndTools; [delta ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "Cristi Bourceanu";
    userEmail = "bourceanu.cristi@gmail.com";
    # TODO = optionalAttrs?
    signing = {
      key           = user-info.gpg.signKey;
      signByDefault = !builtins.isNull user-info.gpg.signKey;
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
      core.editor = "nvim";
      github.user = "crisbour";
      url."git@github.com:crisbour/" = {
        insteadOf = [
          "me:"
          "https://github.com/crisbour/"
        ];
      };
      url."ssh://git@github.com" = lib.mkIf (!builtins.isNull user-info.gpg.signKey) {
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

}
