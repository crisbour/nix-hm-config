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
    age = {
      sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      keyFile = "${config.home.homeDirectory}/config/sops-nix/age/keys.txt";
      generateKey = true;
    };
    # Register which secrets to load from the SOPS file
    secrets = {
      elm_api_key      = {};
      morph_api_key    = {};
      tavily_api_key   = {};
    };
  };

  # Ensure sops-nix service runs before other services that depend on secrets
  systemd.user.services.sops-nix.Unit.After = [ "gnupg-agent.service" ];

}
