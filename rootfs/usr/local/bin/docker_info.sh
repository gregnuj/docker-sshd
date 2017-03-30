#!/bin/bash -e

# Set 'DEBUG=1' environment variable to see detailed output for debugging
if [[ ! -z "$DEBUG" && "$DEBUG" != 0 && "${DEBUG^^}" != "FALSE" ]]; then
  set -x
fi

declare FQDN="${FQDN:=""}"
declare NAME_SERVER="${NAME_SERVER:=""}"
declare SERVICE_NAME="${SERVICE_NAME:=""}"
declare SERVICE_HOSTNAME="${SERVICE_HOSTNAME:=""}"
declare SERVICE_INSTANCE="${SERVICE_INSTANCE:=""}"
declare CONTAINER_NAME="${CONTAINER_NAME:=""}"
declare NODE_ADDRESS="${NODE_ADDRESS:=""}"

function name_server(){
    if [[ -z "$NAME_SERVER" ]] ; then
        NAME_SERVER="$(awk '/nameserver/{print $2}' /etc/resolv.conf | tail -n1)"
    fi
    echo "$NAME_SERVER"
}

function node_address(){
    while [[ -z "$NODE_ADDRESS" ]] ; do
        NODE_ADDRESS="$(hostname -i | awk '{print $1}')"
        if [[ -z "$NODE_ADDRESS" ]] ; then
	    echo "Waiting for dns..." >&2
       	    sleep 1;
	    LOOP=$((LOOP + 1));
        fi
    done
    echo "$NODE_ADDRESS"
}

function fqdn(){
    while [[ -z "$FQDN" && $LOOP -lt 30 ]] ; do
        FQDN="$(nslookup "$(node_address)" "$(name_server)" | awk -F'= ' 'NR==5 { print $2 }')"
        SERVICE_NAME="$(echo "$FQDN" | awk -F'.' '{print $1}')"
        SERVICE_LOOKUP="$(getent hosts tasks.${SERVICE_NAME})"
        if [[ -z "${SERVICE_LOOKUP}" ]]; then
            FQDN=""
        fi
    done
    echo "$FQDN"
}

function service_hostname(){
    if [[ -z "$SERVICE_HOSTNAME" ]] ; then
        SERVICE_HOSTNAME="$(echo "$(fqdn)" | awk -F'.' '{print $1 "." $2}')"
    fi
    echo "$SERVICE_HOSTNAME"
}

function service_name(){
    if [[ -z $SERVICE_NAME ]] ; then
        SERVICE_NAME="$(echo "$(fqdn)" | awk -F'.' '{print $1}')"
    fi
    echo "$SERVICE_NAME"
}

function service_instance(){
    if [[ -z $SERVICE_INSTANCE ]] ; then
        SERVICE_INSTANCE="$(echo "$(fqdn)" | awk -F'.' '{print $2}')"
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
        -f|--fqdn)
	    echo "$(fqdn)"
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

