{
  programs.browserpass = {
    enable = true;
    browsers = [ "brave" ];
  };
  programs.brave = {
    enable = true;
    extensions = [
      "naepdomgkenhinolocfifgehidddafch" # BrowserPass
      "bfhkfdnddlhfippjbflipboognpdpoeh" # reMarkable
      "ffbkglfijbcbgblgflchnbphjdllaogb" # CyberGhost
      "dagcmkpagjlhakfdhnbomgmjdpkdklff" # Mendeley
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # Zotero Connector
    ];
  };
}
