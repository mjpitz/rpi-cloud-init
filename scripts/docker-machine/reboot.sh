#!/usr/bin/env bash

export NETWORK_IP=${NETWORK_IP:-192.168.4.1}
readonly ip_prefix=${NETWORK_IP%.1}

function reboot_host() {
  static_ip="${1}"
  host="ip-${static_ip//./-}"

  docker-machine ssh "${host}" "sudo reboot"
}

function reboot_zone() {
    prefix=${1}
    start=${2}
    end=${3}

    for i in $(seq ${start} ${end}); do
        static_ip="${prefix}.${i}"
        echo "rebooting ${static_ip}"
        reboot_host "${static_ip}"
    done
}

reboot_zone ${ip_prefix} 50 54
reboot_zone ${ip_prefix} 60 64
reboot_zone ${ip_prefix} 70 74
