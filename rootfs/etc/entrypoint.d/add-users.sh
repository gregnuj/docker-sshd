#!/bin/bash

for USER in ${APP_USERS}; do
    if [[ ! -z "${USER}" ]]; then
        if [[ -d "/home/${USER}" ]]; then
            ls -la /home | grep "${USER}" |
            awk "{print \"useradd\", \"-u\", \$3, \"-g\", \$4, \"-s\", \"/bin/bash\", \"${USER}\"}" |
	    while read command; do $command; done
        fi
    fi
done
