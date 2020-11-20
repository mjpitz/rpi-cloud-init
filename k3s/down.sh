#!/usr/bin/env bash

export NETWORK_IP=${NETWORK_IP:-192.168.4.1}
readonly ip_prefix=${NETWORK_IP%.1}

function stop_zone() {
  prefix="${1}"
  start=${2}
  end=${3}

  for i in $(seq $(( start+1 )) ${end}); do
    exec_ip="${prefix}.${i}"
    exec_host="ip-${exec_ip//./-}"

    eval $(docker-machine env "${exec_host}")
    echo "stopping agent ${exec_ip}"
    docker rm -f k3s
    docker-machine ssh ${exec_host} "sudo rm -rf /etc/rancher/k3s"
  done

  control_ip="${prefix}.${start}"
  control_host="ip-${control_ip//./-}"

  eval $(docker-machine env "${control_host}")
  echo "stopping server ${control_ip}"
  docker rm -f k3s
  docker-machine ssh ${control_host} "sudo rm -rf /etc/rancher/k3s /var/lib/rancher/k3s"
}

stop_zone ${ip_prefix} 50 54
#stop_zone ${ip_prefix} 60 64
#stop_zone ${ip_prefix} 70 74
