{ inputs, outputs, lib, pkgs, ... }:
{
  imports = [
    ./base
    ./features/auth
    ./features/desktop/alacritty
    ./features/desktop/gnome
    ./features/devtools
    ./features/desktop/channels
    ./features/desktop/productivity
    ./features/desktop/electronics
    # TODO Configure secrets
    #./features/pass
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

}
