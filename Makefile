clean:
	rm -rf cloud-init/generated/

VALUES ?= values
.helm:
	@helm upgrade --atomic --create-namespace -i $(NAME) $(CHART) -n $(NAMESPACE) -f $(CHART)/$(VALUES).yaml

# CLOUD-INIT

cloud-init: cloud-init/generated
cloud-init/generated: cloud-init/templates/* cloud-init/generate.sh
	@bash cloud-init/generate.sh

# STORAGE

crdb:
	cd storage/crdb && \
		terraform init && \
		terraform apply

minio:
	cd storage/minio && \
		terraform init && \
		terraform apply

# COMPUTE

k3s:
	cd compute/k3s && \
		terraform init && \
		terraform apply

# WORKLOADS

k8s/services:
	make .helm NAMESPACE=default NAME=services CHART=./compute/workloads/services

k8s/aetherfs:
	make .helm NAMESPACE=default NAME=aetherfs CHART=./compute/workloads/aetherfs VALUES=secrets

k8s/cert-manager:
	make .helm NAMESPACE=cert-manager NAME=cert-manager CHART=./compute/workloads/cert-manager

k8s/grafana:
	make .helm NAMESPACE=monitoring NAME=grafana CHART=./compute/workloads/grafana VALUES=secrets

k8s: k8s/services k8s/cert-manager k8s/grafana
