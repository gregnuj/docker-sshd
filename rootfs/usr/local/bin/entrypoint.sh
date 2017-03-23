#!/bin/ash
for script in $(ls /etc/entrypoint.d/*.sh); do 
    echo "$0: running $script"
    $script
    echo
done

exec $@
