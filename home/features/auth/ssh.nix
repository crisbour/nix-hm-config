{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      nexus = {
        hostname = "adventure-bytes.com";
        user = "cristi";
        port = 5022;
        forwardAgent = true;
      };

      blazer = {
        hostname = "w9098.hyena-royal.ts.net";
        user = "cristi";
        port = 22;
        forwardAgent = true;
      };

      sudo-cruncher = {
        hostname = "cruncher-w8802.hyena-royal.ts.net";
        #hostname = "192.41.113.134";
        user = "cruncher-sudo";
        port = 22;
        forwardAgent = true;
      };

      cruncher = {
        hostname = "cruncher-w8802.hyena-royal.ts.net";
        #hostname = "192.41.113.134";
        user = "cristi";
        port = 22;
        forwardAgent = true;
      };

      lab = {
        hostname = "w6725.hyena-royal.ts.net";
        user = "cristi";
        port = 22;
        forwardAgent = true;
      };

      lab-wsl = {
        hostname = "eng-7383-wsl.hyena-royal.ts.net";
        user = "cristi";
        port = 22;
        forwardAgent = true;
      };
    };
  };
}
