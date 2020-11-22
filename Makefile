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

.k8s/namespace:
	@kubectl create ns $(NAMESPACE) 2>/dev/null || { echo "already exists"; }

.k8s:
	helm upgrade -i $(NAME) $(CHART) -n $(NAMESPACE) -f k8s/$(NAMESPACE)/$(VALUES).yaml

k8s/cert-manager: .k8s/cert-manager
.k8s/cert-manager:
	make .k8s/namespace NAMESPACE=cert-manager
	make .k8s NAMESPACE=cert-manager NAME=cert-manager CHART=jetstack/cert-manager VALUES=values

k8s/consul: .k8s/consul
.k8s/consul:
	make .k8s/namespace NAMESPACE=consul
	make .k8s NAMESPACE=consul NAME=consul CHART=hashicorp/consul VALUES=values

k8s/depscloud: .k8s/depcloud
.k8s/depscloud/postgresql-dev:
	make .k8s/namespace NAMESPACE=depscloud
	make .k8s NAMESPACE=depscloud NAME=postgresql-dev CHART=mjpitz/postgresql-dev VALUES=postgresql-dev-values
	#make .k8s NAMESPACE=depscloud NAME=depscloud CHART=depscloud/depscloud VALUES=depscloud-values
	# use local ref until I publish a new version of the chart
	#make .k8s NAMESPACE=depscloud NAME=depscloud CHART=../../depscloud/deploy/charts/depscloud VALUES=depscloud-values
