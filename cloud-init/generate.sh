#!/usr/bin/env bash
export ADMIN_USER=${ADMIN_USER:-mjpitz}

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

readonly default_ssh_public_key_path="${HOME}/.ssh/id_rsa.pub"
readonly ssh_public_key_path="${SSH_KEY_PATH:-"$default_ssh_public_key_path"}"
readonly ssh_public_key=$(cat "${ssh_public_key_path}")

function generate_host() {
    static_ip="${1}"
    host="ip-${static_ip//./-}"

    templates="${SCRIPT_DIR}/templates"
    generated="${SCRIPT_DIR}/generated/${host}"
    mkdir -p "${generated}"

    # WIFI_SSID=""
    # WIFI_PASSWORD=""

    export SSH_PUBLIC_KEY="${ssh_public_key}"
    export HOST="${host}"
    export STATIC_IP="${static_ip}"
    export UPTIME='$UPTIME'

    envsubst < ${templates}/network-config.yaml > ${generated}/network-config
    envsubst < ${templates}/user-data.yaml > ${generated}/user-data
    envsubst < ${templates}/ssh > ${generated}/ssh
    envsubst < ${templates}/nobtcmd.txt > ${generated}/nobtcmd.txt
}

function generate_zone() {
    prefix=${1}
    start=${2}
    end=${3}

    for i in $(seq ${start} ${end}); do
        static_ip="${prefix}.${i}"
        echo "generating ${static_ip}"
        generate_host "${static_ip}"
    done
}

generate_zone 192.168.1 50 54
generate_zone 192.168.1 60 64
generate_zone 192.168.1 70 74
