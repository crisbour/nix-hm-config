{ inputs, outputs, lib, pkgs, ... }:
{
  imports = [
    ./base
    ./features/auth
    ./features/desktop/alacritty
    ./features/desktop/gnome
    ./features/productivity
    ./features/devtools
  ];

  nixpkgs = {
    overlays = [
        # Get around the issue with openssh on RPM distros: https://nixos.wiki/wiki/Nix_Cookbook
        (final: prev: { openssh = prev.openssh_gssapi; } )
    ];
  };

  home.packages = with pkgs; [
    freerdp
  ];

  home = {
    # FIXME: Inherit variables
    username = builtins.getEnv "USER";
    homeDirectory = /. + builtins.getEnv "HOME";
    user-info = {
      fullName      = "Cristian Bourceanu";
      email         = "cristian.bourceanu@codasip.com";
      gpg.enable    = true;
      gpg.masterKey = "0x152B728E9A90E3ED";
      gpg.signKey   = "0x75A90598348541DF";
    };
  };
}
