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
    };
  };
}
