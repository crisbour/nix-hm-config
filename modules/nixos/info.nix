{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.mySystem.info = {
    hostname = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    has_gui = mkOption {
      type = with types; bool;
      default = false;
    };
    has_nvidia = mkOption {
      type = with types; bool;
      default = false;
    };
    has_intel = mkOption {
      type = with types; bool;
      default = false;
    };
  };
}
