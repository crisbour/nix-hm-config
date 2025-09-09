{ ... }:
{
  imports = [
    ./base
    ./features/cli
    ./features/devtools
  ];

  home = {
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
    user-info = {
      fullName      = "Cristian Bourceanu";
      email         = "v.c.bourceanu@sms.ed.ac.uk";
    };
  };
}
