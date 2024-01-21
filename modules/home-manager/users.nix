{ lib, ... }:

let
  inherit (lib) mkOption types;
in

{
  options.home.user-info = {
    username = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    fullName = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    email = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    github = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    gpg = {
      enable = mkOption {
        type = with types; bool;
        default = false;
      };
      masterKey = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      signKey = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };
  };
}
