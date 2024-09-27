{
  virtualisation.docker = {
    enable = true;
  };

  users.users.cristi.extraGroups = ["docker"];
}
