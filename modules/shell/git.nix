{ config, pkgs, lib, ... }: {
    enable = true;
    userEmail = "cristian.bourceanu@codasip.com";
    userName = "Cristian Bourceanu";
    # TODO: add signing
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
    ignores = [
      "build" # build directory
      ".idea" ".vs" ".vsc" ".vscode" # ide
      "__pycache__" "*.pyc" # python
    ];
    extraConfig = {
      init = { defaultBranch = "main"; };
      pull = {
        ff = false;
        commit = false;
        rebase = true;
      };
      push = {
        default = "upstream";
	autoSetupRemote = true;
      };
      #url = {
        #"ssh://git@github.com" = { insteadOf = "https://github.com"; };
      #};
      delta = {
	enable = true;
        line-numbers = true;
      };
    };
}
