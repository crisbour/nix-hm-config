{ inputs, outputs, lib, pkgs, ... }:
{
  imports = [
    ./base
    ./features/auth
    ./features/cli
    ./features/devtools
    #./features/productivity
    ./features/pass
    #./features/nfs
  ];

  home = {
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
    user-info = {
      username      = "cristi";
      fullName      = "Cristi Bourceanu";
      email         = "bourceanu.cristi@gmail.com";
      github        = "crisbour";
      gpg.enable    = true;
      gpg.masterKey = "0xAEF4A543011E8AC1";
      gpg.signKey   = "0xA6307A244F3BD76D";
    };
  };

  home.sessionVariables = {
    # Necessary for pinentry-qt
    QT_QPA_PLATFORM = "xcb";
  };

  home.packages = [ pkgs.browserpass ];
  #programs.browserpass = {
  #  enable = true;
  #};

  xdg = {
    enable = true;
  };

  # Add this to disable dconf which is not available in WSL environment
  dconf.enable = false;

}
