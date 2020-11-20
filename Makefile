clean:
	rm -rf cloud-init/generated/

cloud-init/generated: cloud-init/templates/* cloud-init/generate.sh
	@bash cloud-init/generate.sh

cloud-init: cloud-init/generated

helm/repos:
	helm repo add jetstack https://charts.jetstack.io
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo update

.k8s:
	@kubectl create ns $(NAMESPACE) 2>/dev/null || { echo "already exists"; }
	helm upgrade -i $(NAME) $(CHART) -n $(NAMESPACE) -f k8s/$(NAME)/values.yaml

k8s/cert-manager: .k8s/cert-manager
.k8s/cert-manager:
	make .k8s NAME=cert-manager CHART=jetstack/cert-manager NAMESPACE=cert-manager

k8s/consul: .k8s/consul
.k8s/consul:
	make .k8s NAME=consul CHART=hashicorp/consul NAMESPACE=consul
