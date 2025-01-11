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
    };
  };
}
