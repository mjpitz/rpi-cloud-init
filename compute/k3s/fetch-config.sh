#!/usr/bin/env bash

which_sed="sed"
if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "on darwin, using gsed"
  which_sed="gsed"
fi

readonly REGION="${REGION:-mjpitz}"
readonly SERVER_IP="${SERVER_IP:-192.168.4.30}"
readonly SERVER_HOST="ip-${SERVER_IP//./-}"


config_file="${HOME}/.kube/${REGION}.yaml"
rm -rf ${config_file}

eval $(docker-machine env ${SERVER_HOST})
docker cp k3s:/etc/rancher/k3s/k3s.yaml "${config_file}"

${which_sed} -i "s/127.0.0.1/${SERVER_IP}/g" "${config_file}"
${which_sed} -i "s/localhost/${SERVER_IP}/g" "${config_file}"
${which_sed} -i "s/default/${REGION}/g" "${config_file}"
