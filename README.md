# rpi-cloud-init
![Google Analytics](https://www.google-analytics.com/collect?v=1&tid=UA-172921913-1&cid=555&t=pageview&ec=repo&ea=open&dp=rpi-cloud-init&dt=rpi-cloud-init)

This repository exists to support my at-home Raspberry Pi cluster.
After seeing interest in similar repositories I've hosted, I decided to clean up my set up.
In this version, I swapped over to using cloud-init, making my setup more declarative.

## 1 - Obtain a base image

I use [Ubuntu 18.04](https://ubuntu.com/download/raspberry-pi).

## 2 - Generate cloud-init

Using `envsubst`, I created a few templates based on files I found in the `system-boot` partition.
To generate a file for each node, simply run the `generate.sh` script.

```
$ WIFI_SSID=name WIFI_PASSWORD=password ./cloud-init/generate.sh
generating 192.168.1.50
generating 192.168.1.51
generating 192.168.1.52
generating 192.168.1.53
generating 192.168.1.54
generating 192.168.1.60
generating 192.168.1.61
generating 192.168.1.62
generating 192.168.1.63
generating 192.168.1.64
generating 192.168.1.70
generating 192.168.1.71
generating 192.168.1.72
generating 192.168.1.73
generating 192.168.1.74
```

The output of this script is a directory full of configurations for your each host.
Host names are computed from the static IP address and are prefixed with `ip-` as such.

```
$ ls -1 cloud-init/generated/
ip-192-168-1-50
ip-192-168-1-51
ip-192-168-1-52
ip-192-168-1-53
ip-192-168-1-54
ip-192-168-1-60
ip-192-168-1-61
ip-192-168-1-62
ip-192-168-1-63
ip-192-168-1-64
ip-192-168-1-70
ip-192-168-1-71
ip-192-168-1-72
ip-192-168-1-73
ip-192-168-1-74
```

Once your configuration has been generated, you can start to work on flashing your base image.

## 3 - Flashing image

1. Using [balenaEtcher](https://www.balena.io/etcher), flash the base image onto your SD card.
2. Once complete, copy the files from the generated host directory to the `system-boot` partition.
3. After copying the files to `system-boot`, you're safe to eject the SD card.

## 4 - Booting up

Once all the flash drives are configured, you should be able to boot them up.
I start wired for the initial boot up because I ran into issues with cloud-init not initializing properly going through wifi.
I was able to reset cloud-init and force a rerun which resolved it.
It just required a little more work.

## 5 - Adding nodes as docker-machines

I treat my laptop as a control plane to the nodes of my cluster.
To do this, I use docker-machine and connect each machine.
This provides a few benefits for my home lab, but the biggest of which is convenience.
I can easily introspect remote machines and docker processes from a single terminal.

```bash
$ ./docker-machine/connect.sh

$ docker-machine ls
NAME              ACTIVE   DRIVER    STATE     URL                       SWARM   DOCKER     ERRORS
ip-192-168-1-50   -        generic   Running   tcp://192.168.1.50:2376           v19.03.8   
ip-192-168-1-51   -        generic   Running   tcp://192.168.1.51:2376           v19.03.8   
ip-192-168-1-52   -        generic   Running   tcp://192.168.1.52:2376           v19.03.8   
ip-192-168-1-53   -        generic   Running   tcp://192.168.1.53:2376           v19.03.8   
ip-192-168-1-54   -        generic   Running   tcp://192.168.1.54:2376           v19.03.8   
ip-192-168-1-60   -        generic   Running   tcp://192.168.1.60:2376           v19.03.8   
ip-192-168-1-61   -        generic   Running   tcp://192.168.1.61:2376           v19.03.8   
ip-192-168-1-62   -        generic   Running   tcp://192.168.1.62:2376           v19.03.8   
ip-192-168-1-63   -        generic   Running   tcp://192.168.1.63:2376           v19.03.8   
ip-192-168-1-64   -        generic   Running   tcp://192.168.1.64:2376           v19.03.8   
ip-192-168-1-70   -        generic   Running   tcp://192.168.1.70:2376           v19.03.8   
ip-192-168-1-71   -        generic   Running   tcp://192.168.1.71:2376           v19.03.8   
ip-192-168-1-72   -        generic   Running   tcp://192.168.1.72:2376           v19.03.8   
ip-192-168-1-73   -        generic   Running   tcp://192.168.1.73:2376           v19.03.8   
ip-192-168-1-74   -        generic   Running   tcp://192.168.1.74:2376           v19.03.8   
```

## 6 - Spinning up k3s

Since much of the k3s HA is experimental, I occasionally need to toggle this configuration.
I'll sometimes run this as a single 15 node cluster or three 5 node clusters.
This process uses the docker-machine setup from the previous step to spin up the k3s elements.

```bash
$ ./k3s/up.sh

$ ls -1 ~/.kube/*.yaml
~/.kube/us-central-1a.yaml
~/.kube/us-central-1b.yaml
~/.kube/us-central-1c.yaml
```

## 7 - Setup GitOps

I use gitops to configure common elements across all my clusters.
This script sets up the fluxcd namespace with two processes: flux and helm-operator.
The helm-operator makes deploying Helm charts to kubernetes easy using Custom Resource Definitions.
Flux is a GitOps controller that makes managing declarative deployments easy.

```bash
$ ./gitops/up.sh

$ kubectl get pods -n fluxcd
NAME                              READY   STATUS    RESTARTS   AGE
flux-memcached-8647794c5f-hp8n7   1/1     Running   0          44h
helm-operator-884686cf6-ggxgl     1/1     Running   0          44h
flux-5d6d8f486c-dm46d             1/1     Running   1          44h
```
