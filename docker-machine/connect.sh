#!/usr/bin/env bash

export ADMIN_USER=${ADMIN_USER:-mjpitz}

export NETWORK_IP=${NETWORK_IP:-192.168.4.1}
readonly ip_prefix=${NETWORK_IP%.1}

readonly default_ssh_key_path="${HOME}/.ssh/id_rsa"
readonly ssh_key_path="${SSH_KEY_PATH:-"$default_ssh_key_path"}"

function connect_host() {
  static_ip="${1}"
  host="ip-${static_ip//./-}"

  if [[ ! -z "${DEBUG}" ]]; then
cat <<EOF
  docker-machine create \
    --driver generic \
    --generic-ip-address "${static_ip}" \
    --generic-ssh-key "${ssh_key_path}" \
    --generic-ssh-port 22 \
    --generic-ssh-user "${ADMIN_USER}" \
    "${host}"
EOF
  fi

  docker-machine create \
    --driver generic \
    --generic-ip-address "${static_ip}" \
    --generic-ssh-key "${ssh_key_path}" \
    --generic-ssh-port 22 \
    --generic-ssh-user "${ADMIN_USER}" \
    "${host}"
}

function connect_zone() {
  prefix=${1}
  start=${2}
  end=${3}

  for i in $(seq ${start} ${end}); do
    static_ip="${prefix}.${i}"
    echo "connecting ${static_ip}"
    connect_host "${static_ip}"
  done
}

connect_zone ${ip_prefix} 50 54
connect_zone ${ip_prefix} 60 64
connect_zone ${ip_prefix} 70 74
