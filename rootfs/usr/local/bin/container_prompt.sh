#!/bin/bash

CLASS_B_NET=$(hostname -i | awk "{print \$1 ~ /^172/ ? \$1 : \$2}")
FQDN=$(nslookup $CLASS_B_NET | awk -F'= ' 'NR==5 { print $2 }' )
HOSTNAME=$(echo $FQDN | awk -F'.' '{print $1 "." $2}')

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
export PS1='\u@$HOSTNAME:\w\$ '

