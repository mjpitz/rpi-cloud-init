# rpi-cloud-init

This repository supports the initialization of my at-home cloud.

## Hardware

- 1x 2013 Apple Mini, running Ubuntu 20.04, amd64
- 3x Raspberry Pi 4 (4GB model), running Ubuntu 20.04, arm64
  - Each have a 512GB SanDisk flash drive (USB 3.0)
- 10x Raspberry Pi 3b+, running Ubuntu 20.04, arm64
- 2x Raspberry pi 3b, running Ubuntu 20.04, arm64

## Cluster

 - Provisioning
   - [cloud-init](cloud-init) - Machine initialization
   - [terraform](https://www.terraform.io/) - Declarative provisioning
 - Storage
   - [CockroachDB](storage/crdb) - General purpose, relational database
   - [MinIO](storage/minio) - General purpose, small-blob storage
 - Compute
   - [docker](https://www.docker.com/) / [docker-machine](scripts/docker-machine) - Containerization (deprecate)
   - [k3s](compute/k3s) - General purpose, compute cluster
   - To do:
     - containerd - Containerization

## Workloads

 - [cert-manager](compute/workloads/cert-manager) - Certificate management
 - [grafana](compute/workloads/grafana) - Data visualization
 - [homestead](https://github.com/mjpitz/homestead) - Index builders that help manage my homestead
 - [services](compute/workloads/services) - Aliases for out-of-cluster services
