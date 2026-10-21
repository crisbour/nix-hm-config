let
  gpgAgentForwarding = {
    RemoteForwards = [
        "/run/user/1000/gnupg/S.gpg-agent run/user/1000/gnupg/S.gpg-agent.extra"
        "/run/user/1000/gnupg/S.gpg-agent.ssh /run/user/1000/gnupg/S.gpg-agent.ssh"
    ];

    StreamLocalBindUnlink = "yes";
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      nexus = {
        Hostname = "adventure-bytes.com";
        User = "cristi";
        Port = 5022;
        ForwardAgent = true;
      };

      blazer = {
        Hostname = "w9098.hyena-royal.ts.net";
        User = "cristi";
        Port = 22;
        ForwardAgent = true;
      };

      sudo-cruncher = {
        Hostname = "cruncher-w8802.hyena-royal.ts.net";
        #Hostname = "192.41.113.134";
        User = "cruncher-sudo";
        Port = 22;
        ForwardAgent = true;
      };

      cruncher = {
        Hostname = "cruncher-w8802.hyena-royal.ts.net";
        #Hostname = "192.41.113.134";
        User = "cristi";
        Port = 22;
        ForwardAgent = true;
      };

      lab = {
        Hostname = "w6725.hyena-royal.ts.net";
        User = "cristi";
        Port = 22;
        ForwardAgent = true;
      };

      lab-wsl = {
        Hostname = "eng-7383-wsl.hyena-royal.ts.net";
        User = "cristi";
        Port = 22;
        ForwardAgent = true;
      };
    };
  };
}
