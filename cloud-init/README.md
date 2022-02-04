# cloud-init

Provides machine initialization through cloud-init.

Ideally, these are relatively small configs to allow for quick starts.
Nothing fancy here, just a little `bash` and `envsubst`.

## 1 - Obtain a base image

I use [Ubuntu 18.04](https://ubuntu.com/download/raspberry-pi).

## 2 - Generate cloud-init

Using `envsubst`, I created a few templates based on files I found in the `system-boot` partition. To generate a file 
for each node, simply run the `make` target.

```
$ WIFI_SSID=name WIFI_PASSWORD=password make cloud-init
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

The output of this script is a directory full of configurations for your each host. I compute host names from the 
assigned static IP address and prefix it with `ip-` as such.

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

Once all the flash drives are configured, you should be able to boot them up. I start wired for the initial boot up 
because I ran into issues with cloud-init not initializing properly going through wifi. I was able to reset cloud-init 
and force a rerun which resolved it. It just required a little more work.
