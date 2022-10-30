image="nixos-base"
instance="nixos"
lxc image show $image; ret=$?

if [ $# -ge 2 ];
then
	echo Too many arguments 
	echo Usage: setup_container_nixos [instance_name]
	exit 2
fi

if [ $# -eq 1 ];
then
	instance=$1
else
	echo Fallback to default instance name: nixos
fi

echo Setting up container $instance from image $image


if [ $ret -eq 1 ];
then
	echo "Base Nix does not exists. Prepaire from ubuntu/focal"
	lxc launch -c security.nesting=true images:ubuntu/focal $instance 
	lxc exec $instance -- apt install --yes curl gnupg2 man-db rsync
	lxc exec $instance -- sudo --user ubuntu --login sh -c "curl --location --silent https://nixos.org/nix/install | sh"
	lxc snapshot $instance $image
	lxc publish $instance/$image --alias $image
else
	echo "Base Nix configure image exists"
	lxc launch -c security.nesting=true $image $instance 
fi

lxc exec $instance -- su --login ubuntu bash -c "echo 'export NIX_PATH=\${HOME}/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels\${NIX_PATH:+:\$NIX_PATH}' >> \${HOME}/.bashrc"
