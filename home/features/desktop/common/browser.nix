{ pkgs, ... }:
{
  programs.browserpass = {
    enable = true;
    browsers = [ "brave" "firefox" ];
  };

  programs.brave = {
    enable = true;
    extensions = [
      "naepdomgkenhinolocfifgehidddafch" # BrowserPass
      "bfhkfdnddlhfippjbflipboognpdpoeh" # reMarkable
      "ffbkglfijbcbgblgflchnbphjdllaogb" # CyberGhost
      "dagcmkpagjlhakfdhnbomgmjdpkdklff" # Mendeley
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # Zotero Connector
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    ];
  };

  home.packages = with pkgs; [
    inputs.zen-browser.default
  ];
}
