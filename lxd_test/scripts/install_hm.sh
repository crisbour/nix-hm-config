instance=$1

lxc exec $1 -- su --login ubuntu bash -c "nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager"
lxc exec $1 -- su --login ubuntu bash -c "nix-channel --update"
lxc exec $1 -- su --login ubuntu bash -c "nix-shell '<home-manager>' -A install"

