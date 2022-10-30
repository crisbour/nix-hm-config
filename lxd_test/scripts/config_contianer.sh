instance=$1
lxc config set $instance security.nesting true
lxc config set $instance raw.idmap "both 1000 1000"
lxc config device add $instance doc disk source=/home/cristi/Documents path=/home/ubuntu/Documents


