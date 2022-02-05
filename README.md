# rpi-cloud-init

This repository supports the initialization of my at-home cloud.

My goal is to build a modular, relatively low-power system.

## Hardware

- 1x 2013 Apple Mini
  - **Operating System / Architecture:** Ubuntu 20.04 / amd64
  - **Specs:** 8 CPU, 16GB RAM, 512GB Disk (eventually 1TB)
  - **Media:**
    - 512GB flash drive (USB 3.0)
  - **Services**: MinIO, k3s (server)
- 3x Raspberry Pi 4
  - **Operating System / Architecture:** Ubuntu 20.04 / arm64
  - **Specs:** 4 CPU, 4GB RAM, 32GB Disk
  - **Media:**
    - 512GB flash drive (USB 3.0)
  - **Services**: CockroachDB
- 8x Raspberry Pi 3b+
  - **Operating System / Architecture:** Ubuntu 20.04 / arm64
  - **Specs:** 4 CPU, 1GB RAM, 32GB Disk
  - **Services**: k3s (agent)

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

<a href="assets/cluster.png"><img alt="cluster diagram" src="assets/cluster.png" width="600"/></a>

## Workloads

 - [cert-manager](compute/workloads/cert-manager) - Certificate management
 - [grafana](compute/workloads/grafana) - Data visualization
 - [homestead](https://github.com/mjpitz/homestead) - Index builders that help manage my homestead
 - [services](compute/workloads/services) - Aliases for out-of-cluster services
