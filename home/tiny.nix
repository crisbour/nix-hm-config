{ ... }:
{
  imports = [ ./base ];

  home = {
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
    user-info = {
      fullName      = "Cristian Bourceanu";
      email         = "cristian.bourceanu@codasip.com";
    };
  };
}
