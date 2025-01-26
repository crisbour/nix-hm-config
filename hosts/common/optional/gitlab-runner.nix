{ pkgs, lib, config, ... }:
{
  boot.kernel.sysctl."net.ipv4.ip_forward" = true; # 1
  virtualisation.docker.enable = true;
  # TODO: Decide if this is necessary at any point
  #virtualisation.containers.enable = true;

  # TODO: Add all runners that I am interested about
  services.gitlab-runner = {
    enable = true;
    settings = {
      concurrent = 4;
      #checkInterval = 30;
    };
    services= {
      # runner for building in docker via host's nix-daemon
      # nix store will be readable in runner, might be insecure
      nix = with lib;{
        # File should contain at least these two variables:
        # `CI_SERVER_URL`
        # `REGISTRATION_TOKEN`
        # TODO How to use secrets for tokens and ssh keys? https://git.eisfunke.com/config/nixos/-/blob/main/nixos/server/gitlab-runner.nix
        authenticationTokenConfigFile = config.sops.templates."gitlab-runner-uoe-auth".path;
        dockerImage = "alpine";
        # Inspired from https://github.com/pcboy/nix-glab-runner/blob/master/configuration.nix
        dockerVolumes = [
          "/certs/client"
          "/cache"
          "/nix/store:/nix/store:ro"
          "/nix/var/nix/db:/nix/var/nix/db:ro"
          "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        dockerPrivileged = true;
        dockerDisableCache = false;
        preBuildScript = pkgs.writeScript "setup-container" ''
          mkdir -p -m 0755 /nix/var/log/nix/drvs
          mkdir -p -m 0755 /nix/var/nix/gcroots
          mkdir -p -m 0755 /nix/var/nix/profiles
          mkdir -p -m 0755 /nix/var/nix/temproots
          mkdir -p -m 0755 /nix/var/nix/userpool
          mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
          mkdir -p -m 1777 /nix/var/nix/profiles/per-user
          mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root
          mkdir -p -m 0700 "$HOME/.nix-defexpr"
          . ${pkgs.nix}/etc/profile.d/nix-daemon.sh
          ${pkgs.nix}/bin/nix-channel --add https://nixos.org/channels/nixos-24.05 nixpkgs
          ${pkgs.nix}/bin/nix-channel --update nixpkgs
          ${pkgs.nix}/bin/nix-env -i ${concatStringsSep " " (with pkgs; [ nix cacert git openssh ])}
        '';
        environmentVariables = {
          ENV = "/etc/profile";
          USER = "root";
          NIX_REMOTE = "daemon";
          PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";
          NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt";
          DOCKER_DRIVER = "overlay2";
          DOCKER_TLS_VERIFY = "1";
          DOCKER_CERT_PATH = "/certs/client";
        };
      };
    };
  };

  sops.templates."gitlab-runner-uoe-auth".content = ''
    CI_SERVER_URL=https://git.ecdf.ed.ac.uk
    CI_SERVER_TOKEN="${config.sops.placeholder."gitlab-ci/token"}"
  '';

  sops.secrets."gitlab-ci/url" = {};
  sops.secrets."gitlab-ci/token" = {};

}
