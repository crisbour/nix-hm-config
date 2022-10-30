instance=nixos
image=nixos-base

lxc stop $instance
lxc delete $instance
lxc image delete $image
