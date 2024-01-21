{ inputs, outputs, lib, pkgs, ... }:
{
  imports = [
    ./base
    ./features/desktop/gnome
    ./features/devtools
    ./features/desktop/channels
    ./features/desktop/productivity
    ./features/desktop/electronic
    ./features/pass
  ];

}
