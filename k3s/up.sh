#!/usr/bin/env bash

export K3S_VERSION="v1.17.4-k3s1"

export SECRET="$(uuidgen)"
export REGION="us-central-1"

function start_control_plane() {
  zone="${1}"
  control_ip="${2}"
  join_ip="${3}"

  k3s_url=""
  cluster_init=""

  if [[ ! -z "${join_ip}" ]];  then
    k3s_url="https://${join_ip}:6443"
  else
    cluster_init="1"
  fi

if [[ ! -z "${DEBUG}" ]]; then
cat <<EOF
  docker run -d \
    --name "k3s-control" \
    --network "host" \
    --restart "always" \
    -e "K3S_TOKEN=${SECRET}" \
    -e "K3S_URL=${k3s_url}" \
    -e "K3S_CLUSTER_INIT=${cluster_init}" \
    -v "/var/lib/rancher/k3s:/var/lib/rancher/k3s" \
    --privileged \
    --tmpfs "/run" \
    --tmpfs "/var/run" \
    rancher/k3s:${K3S_VERSION} \
    server \
    --disable servicelb \
    --disable traefik \
    --node-label "node.kubernetes.io/instance-type=rpi-4" \
    --node-label "topology.kubernetes.io/region=${REGION}" \
    --node-label "topology.kubernetes.io/zone=${REGION}${zone}"
EOF
fi

  docker run -d \
    --name "k3s-control" \
    --network "host" \
    --restart "always" \
    -e "K3S_TOKEN=${SECRET}" \
    -e "K3S_URL=${k3s_url}" \
    -e "K3S_CLUSTER_INIT=${cluster_init}" \
    -v "/var/lib/rancher/k3s:/var/lib/rancher/k3s" \
    --privileged \
    --tmpfs "/run" \
    --tmpfs "/var/run" \
    rancher/k3s:${K3S_VERSION} \
    server \
    --disable servicelb \
    --disable traefik \
    --node-label "node.kubernetes.io/instance-type=rpi-4" \
    --node-label "topology.kubernetes.io/region=${REGION}" \
    --node-label "topology.kubernetes.io/zone=${REGION}${zone}"

  config_file="${HOME}/.kube/${REGION}${zone}.yaml"
  rm -rf ${config_file}
  attempts=0
  while [[ ! -e ${config_file} ]] && [[ $(( attempts )) -lt 30 ]]; do
    attempts=$(( attempts + 1 ))
    echo "attempt ${attempts}"
    sleep 5
    docker cp k3s-control:/etc/rancher/k3s/k3s.yaml ${config_file}
  done

  if [[ ! -e ${config_file} ]]; then
    echo "failed to copy out kubeconfig.yaml after 30 attempts"
    exit 1
  fi

  # simple replacements
  sed -i "s/127.0.0.1/${control_ip}/g" ${config_file}
  sed -i "s/localhost/${control_ip}/g" ${config_file}
  sed -i "s/default/${REGION}${zone}/g" ${config_file}
}

function start_worker() {
  zone="${1}"
  control_ip="${2}"

if [[ ! -z "${DEBUG}" ]]; then
cat <<EOF
  docker run -d \
    --name "k3s-exec" \
    --network "host" \
    --restart "always" \
    -e "K3S_TOKEN=${SECRET}" \
    -e "K3S_URL=https://${control_ip}:6443" \
    --privileged \
    --tmpfs "/run" \
    --tmpfs "/var/run" \
    rancher/k3s:${K3S_VERSION} \
    agent \
    --node-label "node.kubernetes.io/instance-type=rpi-3b+" \
    --node-label "topology.kubernetes.io/region=${REGION}" \
    --node-label "topology.kubernetes.io/zone=${REGION}${zone}"
EOF
fi

  docker run -d \
    --name "k3s-exec" \
    --network "host" \
    --restart "always" \
    -e "K3S_TOKEN=${SECRET}" \
    -e "K3S_URL=https://${control_ip}:6443" \
    --privileged \
    --tmpfs "/run" \
    --tmpfs "/var/run" \
    rancher/k3s:${K3S_VERSION} \
    agent \
    --node-label "node.kubernetes.io/instance-type=rpi-3b+" \
    --node-label "topology.kubernetes.io/region=${REGION}" \
    --node-label "topology.kubernetes.io/zone=${REGION}${zone}"
}

function start_zone() {
  zone="${1}"
  prefix="${2}"
  start=${3}
  end=${4}
  join_ip="${5}"

  control_ip="${prefix}.${start}"
  control_host="ip-${control_ip//./-}"
  eval $(docker-machine env "${control_host}")

  echo "starting control plane ${control_ip}"
  start_control_plane "${zone}" "${control_ip}" "${join_ip}"

  for i in $(seq $(( start+1 )) ${end}); do
    exec_ip="${prefix}.${i}"
    exec_host="ip-${exec_ip//./-}"
    eval $(docker-machine env "${exec_host}")

    echo "starting exec ${exec_ip}"
    start_worker "${zone}" "${control_ip}"
  done
}

start_zone a 192.168.1 50 54
start_zone b 192.168.1 60 64 192.168.1.50
start_zone c 192.168.1 70 74 192.168.1.50
