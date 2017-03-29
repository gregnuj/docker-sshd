#!/bin/bash -e

# Set 'DEBUG=1' environment variable to see detailed output for debugging
if [[ ! -z "$DEBUG" && "$DEBUG" != 0 && "${DEBUG^^}" != "FALSE" ]]; then
  set -x
fi

declare SERVICE_NAME="${SERVICE_NAME:=""}"
declare SERVICE_HOSTNAME="${SERVICE_HOSTNAME:=""}"
declare SERVICE_INSTANCE="${SERVICE_INSTANCE:=""}"
declare CONTAINER_NAME="${CONTAINER_NAME:=""}"
declare NODE_ADDRESS="${NODE_ADDRESS:=""}"

function service_hostname(){
    while [[ -z "$SERVICE_HOSTNAME" ]] ; do
        SERVICE_HOSTNAME="$(hostname -i | nslookup | awk -F'= ' 'NR==5 { print $2 }'| awk -F'.' '{print $1 "." $2}')"
        if [[ -z "$SERVICE_HOSTNAME" ]] ; then
	    echo "Waiting for dns..." >&2
       	    sleep 1;
	    LOOP=$((LOOP + 1));
        fi
    done
    echo "$SERVICE_HOSTNAME"
}

function service_name(){
    if [[ -z $SERVICE_NAME ]] ; then
        SERVICE_HOSTNAME="$(service_hostname)"
        SERVICE_NAME="${SERVICE_HOSTNAME%%.*}"
    fi
    echo "$SERVICE_NAME"
}

function service_instance(){
    if [[ -z $SERVICE_INSTANCE ]] ; then
        SERVICE_HOSTNAME="$(service_hostname)"
        SERVICE_INSTANCE="${SERVICE_HOSTNAME##*.}"
    fi
    echo "$SERVICE_INSTANCE"
}

function container_name(){
    if [[ -z $CONTAINER_NAME ]] ; then
        SERVICE_NAME="$(service_name)"
        CONTAINER_NAME="${SERVICE_NAME##*_}"
    fi
    echo "$CONTAINER_NAME"
}

function node_address(){
    while [[ -z "$NODE_ADDRESS" ]] ; do
        NODE_ADDRESS="$(hostname -i)"
        if [[ -z "$NODE_ADDRESS" ]] ; then
	    echo "Waiting for dns..." >&2
       	    sleep 1;
	    LOOP=$((LOOP + 1));
        fi
    done
    echo "$NODE_ADDRESS"
}

function main(){
    case "$1" in
        -a|--address)
	    echo "$(node_address)"
            ;;
        -c|--container)
	    echo "$(container_name)"
            ;;
        -i|--instance)
	    echo "$(service_instance)"
            ;;
        -h|--hostname)
	    echo "$(service_hostname)"
            ;;
        -s|--service)
	    echo "$(service_name)"
            ;;
    esac
}

main "$@"

