{ pkgs, ... }:
{
  programs.browserpass = {
    enable = true;
    browsers = [ "brave" "firefox" ];
  };

  #programs.brave = {
  #  enable = true;
  #  extensions = [
  #    "naepdomgkenhinolocfifgehidddafch" # BrowserPass
  #    "bfhkfdnddlhfippjbflipboognpdpoeh" # reMarkable
  #    "ffbkglfijbcbgblgflchnbphjdllaogb" # CyberGhost
  #    "dagcmkpagjlhakfdhnbomgmjdpkdklff" # Mendeley
  #    "ekhagklcjbdpajgpjgmbionohlpdbjgc" # Zotero Connector
  #    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
  #  ];
  #};

  config.stylix.targets.zen-browser.enable = true;

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    profiles.default.settings = {
      "zen.workspaces.continue-where-left-off" = true;
      "zen.view.compact.hide-tabbar" = true;
      "zen.urlbar.behavior" = "floating-on-type";
      "zen.welcome-screen.seen" = true;
    };

    # Catppuccin theme (catppuccin/zen-browser), symlinked into the profile's
    # chrome/catppuccin and loaded via userChrome/userContent imports.
    profiles.default.presets.catppuccin = {
      enable = true;
      flavor = "Mocha"; # Frappe | Latte | Macchiato | Mocha
      accent = "Mauve"; # Blue, Flamingo, Green, Lavender, Maroon, Mauve, ...
    };

    policies = let
      mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
        installation_mode = "force_installed";
      });
    in {
      ExtensionSettings = mkExtensionSettings {
        "browserpass@maximbaz.com" = "browserpass-ce";
        "{585280b0-ee78-428a-92c5-3fb3c0b85460}" = "cyberghost-vpn-free-proxy";
        "uBlock0@raymondhill.net" = "ublock-origin";
        "zotero@chnm.gmu.edu" = "zotero-connector";
        "remarkable-firefox@lilleengen.io" = "read-on-remarkable-unofficial";
        "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
      };
    };

    profiles.default.search = {
      force = true; # Enforce declared search engines on each rebuild
      default = "ddg";
      engines = {
        mynixos = {
          name = "My NixOS";
          urls = [
            {
              template = "https://mynixos.com/search?q={searchTerms}";
              params = [
                {
                  name = "query";
                  value = "searchTerms";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@nx"];
        };
        github = {
          name = "GitHub Search";
          urls = [
            {
              template = "https://github.com/search?q={searchTerms}";
            }
          ];
          definedAliases = ["@gh"];
        };
      };
    };
  };
}
