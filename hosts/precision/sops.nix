{ inputs, ... }:
{
  imports = [
    # Configuration via home.nix
    inputs.sops-nix.nixosModules.sops
  ];

  # TODO: Wrapt it up in a module an configure it from mySystem top settings
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    # Choose what decryption method to use
    #gnupg.home = "/home/cristi/.gnupg";
    #gnupg.sshKeyPaths = [];
    age = {
      #sshKeyPaths = ["/home/cristi/.ssh/id_ed25519"];
      sshKeyPaths = ["/root/.ssh/id_ed25519"];
      keyFile = "/var/lib/sops-nix/keys.txt";
      generateKey = true;
    };
  };

}
