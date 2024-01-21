{ inputs, outputs, lib, pkgs, ... }:
{
  imports = [
    ./base
    ./features/desktop/gnome
    ./features/desktop/productivity
    ./features/devtools
  ];

  nixpkgs = {
    overlays = [
        # Get around the issue with openssh on RPM distros: https://nixos.wiki/wiki/Nix_Cookbook
        (final: prev: { openssh = prev.openssh_gssapi; } )
    ] ++ builtins.getAttrsValue outputs.overlays;
  };

  home.packages = with pkgs; [
    freerdp
  ];

}
