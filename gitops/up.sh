#!/usr/bin/env bash

readonly namespace="${NAMESPACE:-fluxcd}"

readonly flux_repository="${FLUX_REPOSITORY:-raspbernetes/flux}"
readonly flux_tag="${FLUX_TAG:-1.18.0}"

readonly flux_state_repository="${FLUX_STATE_REPOSITORY:-git@github.com:mjpitz/rpi-cloud-init.git}"
readonly flux_state_authkey="${FLUX_STATE_AUTHKEY:-$HOME/.ssh/fluxcd}"

readonly helm_operator_repository="${HELM_OPERATOR_REPOSITORY:-raspbernetes/helm-operator}"
readonly helm_operator_tag="${HELM_OPERATOR_TAG:-v1.0.0-rc9}"

cat <<EOF
cluster: $(kubectl config current-context)

flux:
    repository: ${flux_repository}
    tag:        ${flux_tag}
    state:
        repository: ${flux_state_repository}
        auth: ${flux_state_authkey}

helm-operator:
    repository: ${helm_operator_repository}
    tag:        ${helm_operator_tag}

---

EOF

if [[ ! -f "${flux_state_authkey}" ]]; then
    echo "generating ${flux_state_authkey}"
    ssh-keygen -t rsa -b 4096 -q -N "" -f "${flux_state_authkey}"
fi

sleep 5

if [[ -z "$(helm repo list | grep fluxcd)" ]]; then
    echo "adding fluxcd repo to helm"
    helm repo add fluxcd https://charts.fluxcd.io
fi

kubectl create ns ${namespace}

#echo "installing flux"
#kubectl create secret generic flux-git-deploy \
#    --namespace ${namespace} \
#    --from-file identity=${flux_state_authkey} \
#    --dry-run \
#    -o yaml | kubectl apply -f -
#
#helm upgrade -i flux fluxcd/flux \
#    --version 1.2.0 \
#    --namespace ${namespace} \
#    --set image.repository=${flux_repository} \
#    --set image.tag=${flux_tag} \
#    --set git.url=${flux_state_repository} \
#    --set git.path=k8s \
#    --set git.readonly=true \
#    --set git.secretName=flux-git-deploy \
#    --set syncGarbageCollection.enabled=true

echo "installing helm-operator"
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

helm upgrade -i helm-operator fluxcd/helm-operator \
    --version 1.0.1 \
    --namespace ${namespace} \
    --set image.repository=${helm_operator_repository} \
    --set image.tag=${helm_operator_tag} \
    --set helm.versions=v3

cat <<EOF

---
Installation complete, be sure to configure the deploy key for the repository:

$(cat ${flux_state_authkey}.pub)
EOF
