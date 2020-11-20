#!/usr/bin/env bash

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

export NETWORK_IP=${NETWORK_IP:-192.168.4.1}
readonly ip_prefix=${NETWORK_IP%.1}

export K3S_VERSION="v1.19.1-k3s1"

export SECRET="$(uuidgen)"
export REGION="${REGION:-mjpitz}"

which_sed="sed"
if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "on darwin, using gsed"
  which_sed="gsed"
fi

function prep_node() {
  name=${1}
  role=${2}
  zone=${3}

  config_blob=$(cat ${SCRIPT_DIR}/config-${role}.yaml | ZONE=${zone} envsubst | base64 -w 0)
  docker-machine ssh ${name} "sudo mkdir -p /etc/rancher/k3s /var/lib/rancher/k3s"
  docker-machine ssh ${name} "echo '${config_blob}' | base64 --decode | sudo tee /etc/rancher/k3s/config.yaml 1>/dev/null"
}

function start_server() {
  zone="${1}"
  server_ip="${2}"
  join_ip="${3}"

  k3s_url=""
  cluster_init=""

  if [[ ! -z "${join_ip}" ]];  then
    k3s_url="https://${join_ip}:6443"
  else
    cluster_init=""
  fi

  docker run -d \
    --name "k3s" \
    --network "host" \
    --restart "always" \
    -e "K3S_TOKEN=${SECRET}" \
    -e "K3S_URL=${k3s_url}" \
    -e "K3S_CLUSTER_INIT=${cluster_init}" \
    -v "/etc/rancher/k3s:/etc/rancher/k3s" \
    -v "/var/lib/rancher/k3s:/var/lib/rancher/k3s" \
    --privileged \
    --tmpfs "/run" \
    --tmpfs "/var/run" \
    rancher/k3s:${K3S_VERSION} \
    server

  config_file="${HOME}/.kube/${REGION}${zone}.yaml"
  rm -rf ${config_file}
  attempts=0
  while [[ ! -e ${config_file} ]] && [[ $(( attempts )) -lt 30 ]]; do
    attempts=$(( attempts + 1 ))
    echo "attempt ${attempts}"
    sleep 5
    docker cp k3s:/etc/rancher/k3s/k3s.yaml ${config_file}
  done

  if [[ ! -e ${config_file} ]]; then
    echo "failed to copy out kubeconfig.yaml after 30 attempts"
    exit 1
  fi

  # simple replacements
  ${which_sed} -i "s/127.0.0.1/${server_ip}/g" ${config_file}
  ${which_sed} -i "s/localhost/${server_ip}/g" ${config_file}
  ${which_sed} -i "s/default/${REGION}${zone}/g" ${config_file}
}

function start_worker() {
  zone="${1}"
  server_ip="${2}"

  docker run -d \
    --name "k3s" \
    --network "host" \
    --restart "always" \
    -e "K3S_TOKEN=${SECRET}" \
    -e "K3S_URL=https://${server_ip}:6443" \
    -v "/etc/rancher/k3s/config.yaml:/etc/rancher/k3s/config.yaml" \
    --privileged \
    --tmpfs "/run" \
    --tmpfs "/var/run" \
    rancher/k3s:${K3S_VERSION} \
    agent
}

function start_zone() {
  zone="${1}"
  prefix="${2}"
  start=${3}
  end=${4}
  join_ip="${5}"

  server_ip="${prefix}.${start}"
  server_host="ip-${server_ip//./-}"

  echo "preparing server ${server_ip}"
  prep_node "${server_host}" "server" "${zone}"

  eval $(docker-machine env "${server_host}")
  echo "starting server ${server_ip}"
  start_server "${zone}" "${server_ip}" "${join_ip}"

  for i in $(seq $(( start+1 )) ${end}); do
    agent_ip="${prefix}.${i}"
    agent_host="ip-${agent_ip//./-}"

    echo "preparing agent ${agent_ip}"
    prep_node "${agent_host}" "agent" "${zone}"

    eval $(docker-machine env "${agent_host}")
    echo "starting agent ${agent_ip}"
    start_worker "${zone}" "${server_ip}"
  done
}

start_zone 1 ${ip_prefix} 50 54
start_zone 2 ${ip_prefix} 60 64 #192.168.1.50
start_zone 3 ${ip_prefix} 70 74 #192.168.1.50
