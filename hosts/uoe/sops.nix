{ inputs, ... }:
{
  imports = [
    # Configuration via home.nix
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    # Choose what decryption method to use
    #gnupg.home = "/home/cristi/.gnupg";
    #gnupg.sshKeyPaths = [];
    age = {
      #sshKeyPaths = ["/home/cristi/.ssh/id_ed25519"];
      sshKeyPaths = ["/home/cristi/.ssh/id_ed25519"];
      keyFile = "/var/lib/sops-nix/keys.txt";
      generateKey = true;
    };
  };

}
