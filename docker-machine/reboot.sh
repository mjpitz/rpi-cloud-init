#!/usr/bin/env bash

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

reboot_zone 192.168.1 50 54
reboot_zone 192.168.1 60 64
reboot_zone 192.168.1 70 74
