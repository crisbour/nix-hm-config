{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      #cdi = true;
      fixed-cidr-v6 = "fd00::/80";
      ipv6 = true;
    };
    enableNvidia = true;
  };
  # HACK: Conditional assert on nvidia driver installed
  hardware.nvidia-container-toolkit.enable = true;

  users.users.cristi.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    docker
  ];
}
