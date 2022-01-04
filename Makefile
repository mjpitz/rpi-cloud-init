clean:
	rm -rf cloud-init/generated/

cloud-init/generated: cloud-init/templates/* cloud-init/generate.sh
	@bash cloud-init/generate.sh

cloud-init: cloud-init/generated

helm/repos:
	helm repo add jetstack https://charts.jetstack.io
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo add mjpitz https://mjpitz.github.io/charts
	helm repo update

.k8s:
	@helm upgrade --atomic --create-namespace -i $(NAME) $(CHART) -n $(NAMESPACE) -f k8s/$(NAME)/$(VALUES).yaml

k8s/aetherfs: .k8s/aetherfs
.k8s/aetherfs:
	make .k8s NAMESPACE=default NAME=aetherfs CHART=./k8s/aetherfs VALUES=secrets

k8s/cert-manager: .k8s/cert-manager
.k8s/cert-manager:
	make .k8s NAMESPACE=cert-manager NAME=cert-manager CHART=./k8s/cert-manager VALUES=values

