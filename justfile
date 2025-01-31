# Inspired from: https://github.com/eh8/chenglab/blob/main/justfile
default:
  just --list

deploy machine ip='':
  #!/usr/bin/env sh
  if [ {{machine}} = "macos" ]; then
    darwin-rebuild switch --flake .
  elif [ -z "{{ip}}" ]; then
    sudo nixos-rebuild switch --fast --flake ".#{{machine}}"
  else
    nixos-rebuild switch --fast --flake ".#{{machine}}" --use-remote-sudo --target-host "eh8@{{ip}}" --build-host "eh8@{{ip}}"
  fi

home conf:
  #!/usr/bin/env sh
  home-manager switch --flake .#{{conf}} --impure

up:
  nix flake update

lint:
  statix check .

gc:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && sudo nix store gc
gc-hm:
  nix-collect-garbage --delete-older-than 7d

repair:
  sudo nix-store --verify --check-contents --repair

sopsedit:
  sops secrets/secrets.yaml

sopsrotate:
  for file in secrets/*; do sops --rotate --in-place "$file"; done

sopsupdate:
  for file in secrets/*; do sops updatekeys "$file"; done

build-iso:
  nix build .#nixosConfigurations.iso1chng.config.system.build.isoImage

update-keys:
  ls secrets/*.yaml | xargs -I {} sops updatekeys -y {}
