{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {

      nexus = {
        hostname = "adventure-bytes.com";
        user = "cristi";
        port = 5022;
      };

      blazer = {
        hostname = "w9098.hyena-royal.ts.net";
        user = "cristi";
        port = 22;
      };

      sudo-cruncher = {
        hostname = "192.41.113.134";
        user = "lab-machine-1";
        port = 22;
      };

      cruncher = {
        hostname = "192.41.113.134";
        user = "cristi";
        port = 22;
      };

      lab = {
        hostname = "eng-7383.hyena-royal.ts.net";
        user = "s2703496";
        port = 22;
      };

      lab-wsl = {
        hostname = "eng-7383-wsl.hyena-royal.ts.net";
        user = "cristi";
        port = 22;
      };
    };
  };
}
