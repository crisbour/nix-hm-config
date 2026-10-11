let
  gpgAgentForwarding = {
    remoteForwards = [
      {
        bind.address = "/run/user/1000/gnupg/S.gpg-agent";
        host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
      }
      {
        bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
        host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
      }
    ];

    extraOptions = {
      StreamLocalBindUnlink = "yes";
    };
  };
in
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
      } // gpgAgentForwarding;

      sudo-cruncher = {
        hostname = "cruncher-w8802.hyena-royal.ts.net";
        #hostname = "192.41.113.134";
        user = "cruncher-sudo";
        port = 22;
        forwardAgent = true;
      } // gpgAgentForwarding;

      cruncher = {
        hostname = "cruncher-w8802.hyena-royal.ts.net";
        #hostname = "192.41.113.134";
        user = "cristi";
        port = 22;
        forwardAgent = true;
      } // gpgAgentForwarding;

      lab = {
        hostname = "w6725.hyena-royal.ts.net";
        user = "cristi";
        port = 22;
        forwardAgent = true;
      } // gpgAgentForwarding;

      lab-wsl = {
        hostname = "eng-7383-wsl.hyena-royal.ts.net";
        user = "cristi";
        port = 22;
        forwardAgent = true;
      } // gpgAgentForwarding;
    };
  };
}
