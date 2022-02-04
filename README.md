# rpi-cloud-init

This repository exists to support my at-home cloud.

## Hardware

- 1x 2013 Apple Mini, running Ubuntu 20.04, amd64
- 3x Raspberry Pi 4 (4GB model), running Ubuntu 20.04, arm64
- 10x Raspberry Pi 3b+, running Ubuntu 20.04, arm64
- 2x Raspberry pi 3b, running Ubuntu 20.04, arm64

## Cluster

 - Provisioning
   - [cloud-init](cloud-init) - Machine initialization
   - [terraform](https://www.terraform.io/) - Declarative provisioning
 - Storage
   - [CockroachDB](crdb) - General purpose, relational database
   - To do:
     - minio - General purpose, small blob storage
 - Compute
   - [docker](https://www.docker.com/) / [docker-machine](docker-machine) - Containerization (deprecate)
   - [k3s](k3s) - General purpose, compute cluster
   - To do:
     - containerd - Containerization

## Workloads

 - [cert-manager](k8s/cert-manager) - Certificate management
 - [crdb](k8s/crdb) - Convenient service definition for dialing the cockroachdb cluster
 - [grafana](k8s/grafana) - Data visualization
 - [homestead](https://github.com/mjpitz/homestead) - Index builders that help manage my homestead
