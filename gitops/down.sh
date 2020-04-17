#!/usr/bin/env bash
set -e -o pipefail

readonly namespace="${HELM_OPERATOR_NAMESPACE:-fluxcd}"

helm uninstall --namespace ${namespace} helm-operator
kubectl delete -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

helm uninstall --namespace ${namespace} flux
kubectl delete secret --namespace ${namespace} flux-git-deploy

kubectl delete ns ${namespace}
