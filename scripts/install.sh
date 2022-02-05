#!/usr/bin/env bash

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

export NETWORK_IP=${NETWORK_IP:-192.168.4.1}
readonly ip_prefix=${NETWORK_IP%.1}

readonly packages="$@"

function install() {
  prefix="${1}"
  start=${2}
  end=${3}

  for i in $(seq ${start} ${end}); do
    ip="${prefix}.${i}"
    host="ip-${ip//./-}"

    docker-machine ssh "${host}" "sudo apt-get install -y ${packages}"
  done
}

install ${ip_prefix} 50 54
install ${ip_prefix} 60 64
