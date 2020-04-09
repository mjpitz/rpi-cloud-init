#!/usr/bin/env bash

function disconnect_host() {
  static_ip="${1}"
  host="ip-${static_ip//./-}"

  docker-machine rm -f "${host}"
}

function disconnect_zone() {
    prefix=${1}
    start=${2}
    end=${3}

    for i in $(seq ${start} ${end}); do
        static_ip="${prefix}.${i}"
        echo "disconnecting ${static_ip}"
        disconnect_host "${static_ip}"
    done
}

disconnect_zone 192.168.1 50 54
disconnect_zone 192.168.1 60 64
disconnect_zone 192.168.1 70 74
