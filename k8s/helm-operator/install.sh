#!/usr/bin/env bash

readonly repository=${HELM_OPERATOR_REPOSITORY:-onedr0p/helm-operator}
readonly tag=${HELM_OPERATOR_TAG:-v1.0.0-rc8}
readonly namespace=${HELM_OPERATOR_NAMESPACE:-fluxcd}

cat <<EOF
configuring helm-operator:
    cluster:    $(kubectl config current-context)
    repository: ${repository}
    tag:        ${tag}
EOF

sleep 5

if [[ -z "$(helm repo list | grep fluxcd)" ]]; then
    echo "adding fluxcd repo to helm"
    helm repo add fluxcd https://charts.fluxcd.io
fi

kubectl create ns ${namespace}

kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/flux-helm-release-crd.yaml

helm upgrade -i helm-operator fluxcd/helm-operator \
    --namespace ${namespace} \
    --set image.repository=${repository} \
    --set image.tag=${tag} \
    --set helm.versions=v3
