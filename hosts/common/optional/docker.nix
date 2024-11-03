{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
  };
  # HACK: Conditional assert on nvidia driver installed
  hardware.nvidia-container-toolkit.enable = true;

  users.users.cristi.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    docker
  ];
}
