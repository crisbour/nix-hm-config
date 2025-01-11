{ config, ... }:
{
  mySystem.docker = {
    enable = true;
    nvidia.enable = config.mySystem.info.has_nvidia;
  };
}
