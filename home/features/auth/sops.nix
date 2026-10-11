{ inputs, config, ... }:
{
  imports = [
    # Configuration via home.nix
    inputs.sops-nix.homeManagerModules.sops
  ];

  # TODO: Wrapt it up in a module an configure it from mySystem top settings
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    # Choose what decryption method to use
    gnupg.home = "/home/cristi/.gnupg";
    gnupg.sshKeyPaths = [];
    #age = {
    #  #sshKeyPaths = [];
    #  #sshKeyPaths = ["/home/cristi/.ssh/id_ed25519"];
    #  #sshKeyPaths = ["/root/.ssh/id_ed25519"];
    #  keyFile = "${config.home.homeDirectory}/config/sops-nix/age/keys.txt";
    #  #generateKey = true;
    #};
    # Register which secrets to load from the SOPS file
    secrets = {
      elm_openai_api_key = {};
      morph_api_key       = {};
      tavily_api_key      = {};
    };
  };

}
