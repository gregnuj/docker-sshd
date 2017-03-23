#!/bin/bash

for USER in ${APP_USERS}; do
    if [[ -d "/home/${USER}" ]]; then
        ls -la /home | grep "${USER}" |
        awk "{print \"useradd\", \"-u\", \$3, \"-g\", \$4, \"-s\", \"/bin/bash\" ${USER}}"
    fi
done
#while read command; do $command; done
