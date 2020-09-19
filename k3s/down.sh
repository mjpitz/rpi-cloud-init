#!/usr/bin/env bash

function stop_zone() {
  prefix="${1}"
  start=${2}
  end=${3}

  control_ip="${prefix}.${start}"
  control_host="ip-${control_ip//./-}"
  eval $(docker-machine env "${control_host}")

  echo "stopping control plane ${control_ip}"
  docker rm -f k3s
  docker-machine ssh ${control_host} "sudo rm -rf /var/lib/rancher/k3s"

  for i in $(seq $(( start+1 )) ${end}); do
    exec_ip="${prefix}.${i}"
    exec_host="ip-${exec_ip//./-}"
    eval $(docker-machine env "${exec_host}")

    echo "stopping exec ${exec_ip}"
    docker rm -f k3s
  done
}

stop_zone 192.168.1 50 54
stop_zone 192.168.1 60 64
stop_zone 192.168.1 70 74
