# Inspired from: https://github.com/jackdbd/nix-config/blob/fda1da9d8c90396a5e350149a25bbee83f882ce0/nixos/modules/secrets.nix#L32
{
  config,
  sops-nix,
  user,
  ...
}: let
  # TODO: Adapt to use this kind of module if moving towards caring for more secrets, such that they are all bundled here regardless of host used

  # The secret's owner. It can be either a user ID or a username.
  # To avoid misconfiguration, prefer using `config.users.users.<?name>.name`
  # instead of hardcoding it.
  owner = config.users.users.${user}.name;

  # The secret's group. It can be either a group ID or a group name.
  # To avoid misconfiguration, prefer using `config.users.users.<?name>.group`
  # instead of hardcoding it.
  group = config.users.users.${user}.group;

  # Permission modes are in octal representation (same as chmod).
  # The digits represent: user|group|owner
  # 7 - full (rwx)
  # 6 - read and write (rw-)
  # 5 - read and execute (r-x)
  # 4 - read only (r--)
  # 3 - write and execute (-wx)
  # 2 - write only (-w-)
  # 1 - execute only (--x)
  # 0 - none (---)
  mode = "0400";
in {
  meta = {};

  imports = [
    sops-nix.nixosModules.sops
  ];

  options = {};

  config = {
    # The sops module of sops-nix has these configuration options:
    # https://github.com/Mic92/sops-nix/blob/master/modules/sops/default.nix

    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#deploy-example
    sops.defaultSopsFile = ../../secrets/secrets.sops.yaml;
    sops.defaultSopsFormat = "yaml";
    # This will be at /run/secrets.d/age-keys.txt
    # sudo ls -la /run/secrets.d/
    sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

    sops.secrets."aws/default" = {
      inherit group mode owner;
      sopsFile = ../../secrets/aws/default.sops.yaml;
    };

    sops.secrets."cal" = {
      inherit group mode owner;
    };

    sops.secrets."clojars" = {
      inherit group mode owner;
    };

    sops.secrets."cloudflare/r2" = {
      inherit group mode owner;
      sopsFile = ../../secrets/cloudflare/default.sops.yaml;
    };

    sops.secrets."cloudflare/tokens" = {
      inherit group mode owner;
      sopsFile = ../../secrets/cloudflare/default.sops.yaml;
    };

    sops.secrets."cloudinary" = {
      inherit group mode owner;
    };

    # The unencrypted value of this secret will be available at runtime at:
    # /run/secrets/elevenlabs/api_key
    sops.secrets."elevenlabs/api_key" = {
      inherit group mode owner;
    };

    sops.secrets."fastly/api_token" = {
      inherit group mode owner;
    };

    sops.secrets."fly/indiekit" = {
      inherit group mode owner;
      sopsFile = ../../secrets/fly/default.sops.yaml;
    };

    sops.secrets."fly/micropub" = {
      inherit group mode owner;
      sopsFile = ../../secrets/fly/default.sops.yaml;
    };

    sops.secrets."fly/tokens" = {
      inherit group mode owner;
      sopsFile = ../../secrets/fly/default.sops.yaml;
    };

    sops.secrets."github-tokens/crud_contents_api" = {
      inherit group mode owner;
    };

    sops.secrets."github-tokens/github_packages_push" = {
      inherit group mode owner;
    };

    sops.secrets."github-tokens/semantic_release_bot" = {
      inherit group mode owner;
    };

    sops.secrets."github-tokens/workflow_developer" = {
      inherit group mode owner;
    };

    sops.secrets."go-jamming" = {
      inherit group mode owner;
    };

    sops.secrets."hacker-news/credentials" = {
      inherit group mode owner;
    };

    sops.secrets."indiekit" = {
      inherit group mode owner;
    };

    sops.secrets."linkedin/trusted_client" = {
      inherit group mode owner;
    };

    sops.secrets."mastodon" = {
      inherit group mode owner;
    };

    sops.secrets."micropub" = {
      inherit group mode owner;
    };

    sops.secrets."miniflux" = {
      inherit group mode owner;
    };

    sops.secrets."ngrok/auth_token" = {
      inherit group mode owner;
    };

    sops.secrets."npm" = {
      inherit group mode owner;
    };

    sops.secrets."npm-tokens/read_all_packages" = {
      inherit group mode owner;
    };

    sops.secrets."npm-tokens/semantic_release_bot" = {
      inherit group mode owner;
    };

    sops.secrets."openai/personal_api_key" = {
      inherit group mode owner;
    };

    sops.secrets."plausible/test_site" = {
      inherit group mode owner;
    };

    sops.secrets."prj-kitchen-sink/sa-firestore-user-test" = {
      inherit group mode owner;
      sopsFile = ../../secrets/gcp/prj-kitchen-sink.sops.yaml;
    };

    sops.secrets."prj-kitchen-sink/sa-firestore-viewer-test" = {
      inherit group mode owner;
      sopsFile = ../../secrets/gcp/prj-kitchen-sink.sops.yaml;
    };

    sops.secrets."prj-kitchen-sink/sa-notifier" = {
      inherit group mode owner;
      sopsFile = ../../secrets/gcp/prj-kitchen-sink.sops.yaml;
    };

    sops.secrets."prj-kitchen-sink/sa-secret-manager-admin-test" = {
      inherit group mode owner;
      sopsFile = ../../secrets/gcp/prj-kitchen-sink.sops.yaml;
    };

    sops.secrets."prj-kitchen-sink/sa-storage-uploader" = {
      inherit group mode owner;
      sopsFile = ../../secrets/gcp/prj-kitchen-sink.sops.yaml;
    };

    sops.secrets."pulumi/access_token" = {
      inherit group mode owner;
    };

    sops.secrets."reddit/trusted_client" = {
      inherit group mode owner;
    };

    sops.secrets."stripe/personal/live" = {
      inherit group mode owner;
    };

    sops.secrets."stripe/personal/test" = {
      inherit group mode owner;
    };

    sops.secrets."syncthing/api_key" = {
      inherit group mode owner;
    };

    sops.secrets."syncthing/gui_credentials" = {
      inherit group mode owner;
    };

    sops.secrets."telegram/jackdbd_github_bot" = {
      inherit group mode owner;
    };

    sops.secrets."telegram/jackdbd_youtube_videos_bot" = {
      inherit group mode owner;
    };

    sops.secrets."telegram/personal_bot" = {
      inherit group mode owner;
    };

    sops.secrets."turso/micropub" = {
      inherit group mode owner;
    };

    sops.secrets."turso/tweedler" = {
      inherit group mode owner;
    };

    sops.secrets."virtual-machines/adc" = {
      inherit group mode owner;
      sopsFile = ../../secrets/gcp/virtual-machines.sops.yaml;
    };

    sops.secrets."webmentions_io_token" = {
      inherit group mode owner;
    };
  };
}
