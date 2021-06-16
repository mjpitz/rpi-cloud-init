# Network Bridge

Honestly, I'm not sure if this should be a `README.md` or a blog post.
So I figured why not both?

It doesn't happen a lot, but every so often I come across a device that isn't wi-fi supported.
This latest case was my security system.
On one hand, I like that my cameras aren't taking up bandwidth on my home network and that the system is largely a closed loop.
On the other hand, not having access to my security system without having it tethered into the router is a bit of a pain.
For one, my home networking setup isn't that elegant (yet).
Second, the last thing I want to do is have more stuff out in the open, co-located with my router.
So I decided to get a little creative.
Sure, I could've bought a wi-fi adapter, but where's the fun in that.
On top of that, I had some other reasons:

1. I didn't know if an adapter would work for this system.
1. I eventually want to do some real-time processing of video feed data and didn't want to stream that over the network.
1. I already have more than a dozen pis around (I wound up using a 3b+ for this).

Today, I describe how I set up and configured a Raspberry Pi to act as a WAN client for connected devices.
There are a handful of similar guides out there, but finding one for this specific direction / configuration was difficult.
Similar guides I used as reference:

- [Setting up a Raspberry Pi as a bridged wireless access point](https://www.raspberrypi.org/documentation/configuration/wireless/access-point-bridged.md)
- [Setting up a Raspberry Pi as a routed wireless access point](https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md)
- [Setting up a Raspberry Pi as an access point](https://raspberrypi.stackexchange.com/questions/88214/setting-up-a-raspberry-pi-as-an-access-point-the-easy-way)
- [Raspberry Pi 4 Model B WiFi Ethernet Bridge](https://willhaley.com/blog/raspberry-pi-wifi-ethernet-bridge/)

Of these guides, "Raspberry Pi 4 Model B WiFi Ethernet Bridge" is the closest.
Unlike many of these guides, I run an Ubuntu arm64 image instead of Raspbian OS.
The process is largely the same, but some tooling is different.
For example, we need to work with netplan (which can be a pain depending on what you're trying to do).
In addition to that, we have a slightly higher resource footprint, but thats not the biggest concern for what this little one is doing.
To help provide a little context as to what's going on here, I've put together this diagram:

[![](https://mermaid.ink/svg/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBjMShDYW1lcmEgMSlcbiAgICBjMihDYW1lcmEgMilcbiAgICBjLihDYW1lcmEgLi4uKVxuICAgIGNuKENhbWVyYSBOKVxuICAgIGh1YihTZWN1cml0eSBIdWIgPGJyPiBldGgwIC0gMTkyLjE2OC4xMC4yKVxuICAgIHBpKFJhc3BiZXJyeSBQaSA8YnI-IHdsYW4wIC0gMTkyLjE2OC40LjMwIDxicj4gZXRoMCAtIDE5Mi4xNjguMTAuMSlcbiAgICBtZShNeWEncyBMYXB0b3AgPGJyPiB3bGFuMCAtIDE5Mi4xNjguNC4xMClcbiAgICByb3V0ZXIoV2ktZmkgUm91dGVyIDxicj4gd2xhbjAgLSAxOTIuMTY4LjQuMSlcblxuICAgIHJvdXRlciAtLi0gbWVcbiAgICByb3V0ZXIgLS4tIHBpXG5cbiAgICBwaSAtLS0gaHViXG4gIFxuICAgIGh1YiAtLS0gYzFcbiAgICBodWIgLS0tIGMyXG4gICAgaHViIC0tLSBjLlxuICAgIGh1YiAtLS0gY25cbiIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2UsImF1dG9TeW5jIjp0cnVlLCJ1cGRhdGVEaWFncmFtIjpmYWxzZX0)](https://mermaid-js.github.io/mermaid-live-editor/edit##eyJjb2RlIjoiZ3JhcGggVERcbiAgICBjMShDYW1lcmEgMSlcbiAgICBjMihDYW1lcmEgMilcbiAgICBjLihDYW1lcmEgLi4uKVxuICAgIGNuKENhbWVyYSBOKVxuICAgIGh1YihTZWN1cml0eSBIdWIgPGJyPiBldGgwIC0gMTkyLjE2OC4xMC4yKVxuICAgIHBpKFJhc3BiZXJyeSBQaSA8YnI-IHdsYW4wIC0gMTkyLjE2OC40LjMwIDxicj4gZXRoMCAtIDE5Mi4xNjguMTAuMSlcbiAgICBtZShNeWEncyBMYXB0b3AgPGJyPiB3bGFuMCAtIDE5Mi4xNjguNC4xMClcbiAgICByb3V0ZXIoV2ktZmkgUm91dGVyKVxuXG4gICAgcm91dGVyIC0uLSBtZVxuICAgIHJvdXRlciAtLi0gcGlcblxuICAgIHBpIC0tLSBodWJcbiAgXG4gICAgaHViIC0tLSBjMVxuICAgIGh1YiAtLS0gYzJcbiAgICBodWIgLS0tIGMuXG4gICAgaHViIC0tLSBjblxuIiwibWVybWFpZCI6IntcbiAgXCJ0aGVtZVwiOiBcImRlZmF1bHRcIlxufSIsInVwZGF0ZUVkaXRvciI6ZmFsc2UsImF1dG9TeW5jIjp0cnVlLCJ1cGRhdGVEaWFncmFtIjpmYWxzZX0)

Alt-text for diagram:
- At the top, there's a wi-fi router that's connected to the public internet who's `wlan0` interface holds the `192.168.4.1` IP address.
- Connected to the router over wi-fi are two machines.
  - First is Mya's laptop who's `wlan0` interface holds the `192.168.4.10` IP address.
  - Second is a Raspberry Pi board who's `wlan0` interface holds the `192.168.4.30` IP address
    and who's `eth0` interface holds the `192.168.10.1` IP address.
- The Security hub connects to the Raspberry Pi's using an ethernet cable.
- Some number of cameras connect to the security hub using a cable.

## Flash Image

For simplicity, I used my `cloud-init` base from this repo to flash my Raspberry Pi (w/ wi-fi access).
This gives it a similar look and feel to many of the other microcomputers I have around the house.
In addition to that, I get some reasonable default security configurations with that setup (i.e. private key access, no root, custom user), etc.
Note that in flashing this image, we should setup wi-fi so the Raspberry Pi can connect to the internet without ethernet.
To get a machine up and running, follow Steps 1 - 4 on the projects [README.md](../README.md).

Once the board is running, we'll need to make some additional modifications to the networking setup.
The `network-config` provided in the `cloud-init` setup generates `/etc/netplan/50-cloud-init.yaml`.
We will be creating a new `/etc/netplan/60-static-eth0.yaml` file with the following contents.

```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      dhcp6: false
      addresses: [192.168.10.1/24]
      gateway4: 192.168.10.1
      nameservers:
        addresses: [192.168.10.1]   
```

This overrides the configuration we provided initially and sets up a private, static IP block for connected devices to use.
We really only need one here, but allocating a block may be useful at some point later on.
With the new file, we need to generate and apply the changes.

```
$ sudo netplan generate
$ sudo netplan apply
``` 

We can verify the changes by inspecting the `ifconfig` (you may need to `apt-get install net-tools`).

```
$ ifconfig
mjpitz@ip-192-168-4-74:~$ ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.10.1  netmask 255.255.255.0  broadcast 192.168.10.255    ###### expected change

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0

wlan0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.4.30  netmask 255.255.255.0  broadcast 192.168.4.255

```

## Software

In order get this to work, I needed to install some basic software components.

- `isc-dhcp-server` is responsible for providing configuration to machines on the underlying network.
- `dnsmasq` does a lot of the heavy lifting by acting as a DNS cache server and router.
- `netfilter-persistent` helps preserve firewall rules and restoring them on reboots.
- `iptables-persistent` helps preserve iptable rules and restoring them on reboots.

```
$ sudo apt-get update -y && sudo apt-get install -y isc-dhcp-server dnsmasq
$ sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent
```

Once installed, we'll need to configure each system.
Note, dnsmasq may be having trouble starting up.
This is OK, we'll fix it.

### dhcp

First up, let's configure dhcp.
For some reason, I couldn't get the system to work without this installed.
I know dnsmasq supports dhcp, but without this process I was getting an error and couldn't obtain a network address.

```
dnsmasq-dhcp[3685]: DHCP packet received on eth0 which has no address
```

First, we'll want to modify `/etc/default/isc-dhcp-server` to point `INTERFACESv4="eth0"`.
This will ensure that the dhcp server responds to request (similar to how your wi-fi router responds to these requests).
Next we need to configure the dhcp server to know about the subnet that we're allocating to it.
To do this, we'll edit `/etc/dhcp/dhcpd.conf` to contain the following contents:

```
# communicates that the Raspberry Pi will act as a router for requests.
host router {
  hardware ethernet "mac of eth0, obtained from ifconfig.eth0.ether attribute";
  fixed-address 192.168.10.1;
}

# communicates how to manage the associated subnet(s)
subnet 192.168.10.0 netmask 255.255.255.0 {
  range 192.168.10.2 192.168.10.254;
  option routers 192.168.10.1;
  option dns-name-servers 192.168.10.1;
}
```

Once dhcp has been configured, you'll need to restart the service.

```
$ sudo service isc-dhcp-server restart
```

Once the dhcp server has been restarted, it should be operating with your new configuration.
We can verify that it's running properly using `sudo service isc-dhcp-server status` or by tailing logs with `sudo journalctl -u isc-dhcp-server`.

### dnsmasq

Next we're going to configure dnsmasq. 
This is responsible for the core configuration logic.
In the default configuration, dnsmasq conflicts with systemd-resolved (which is why the service likely couldn't start).
We'll be modifying its configuration to bind dnsmasq to eth0 allowing it to respond to requests.
To do so, we'll backup the existing configuration and create a new file.

```
$ sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
```

Next, we'll create a new `/etc/dnsmasq.conf` with the following content.

```
interface=eth0                              # what interface to bind to.
listen-address=192.168.10.1                 # what addresses to listen on.
bind-interfaces                             # binds to all interfaces, even if we're only listening on some.
server=192.168.4.1                          # sets the upstream router as a dns server for delegation.
dhcp-range=192.168.10.2,192.168.10.254,12h  # configures the lease time for dhcp requests.
```

Once we configure dnsmasq, we'll need to restart it for our changes to take effect.

```
$ sudo service dnsmasq restart
```

Once restarted, dnsmasq should come up without an issue.
We can check its status using `sudo service dnsmasq status` or by tailing logs with `sudo journalctl -u dnsmasq`.
Before requests can successfully pass through the dnsmasq, we need to configure some lower level networking.

### (GNU/?)Linux networking

The last part of this configuration requires modifying the (GNU/?)Linux networking components.
I say (GNU/?)Linux because I'm not entirely sure where iptables falls in that delineation.
Gut feeling is Linux, but I've never actually gone down that rabbit whole to verify.

To do this, we'll first want to configure the kernel to do packet forwarding for IPv4.
Open `/etc/sysctl.conf`, uncomment the line containing `net.ipv4.ip_forward=1`, and save.
To reload the configuration without a full system reboot, run the following command. 

```
$ sudo sysctl --system
```

Next, we'll instruct IP tables to allow masquerading over the wlan0 interface.
This allows requests to pass through the network interfaces with very little software in between.
Once modified, we'll need to persist changes using `netfilter-persistent` so changes persist between reboots.

```
$ sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
$ sudo netfilter-persistent save
```

### Verifying client

Once all of this is done, traffic should flow from the connected device through to other devices on the network or internet.
We can verify this by connecting a device to the Raspberry Pi.
It should successfully negotiate an IP address from the dchp server (likely `192.168.10.2`).
In addition to that, we should be able to make requests from the client (i.e. the security system) to other devices on your network or internet.

Once I connected my system, I saw that it successfully obtain an IP from the server using the UI they provide.
After, I sent a test email to make sure the request would successfully go through.
While doing this, I brought up a terminal on the Raspberry Pi to watch the traffic flow (`sudo tcpdump -X -i eth0`).
At this point, I'm leagues ahead of where I was before.
When I went to set up cloud backups, I learned that needed to be done through their mobile app.
As a result, I needed to expose the client application ports through the Raspberry Pi in order to connect from my devices.

### Exposing ports

The system I bought exposed two ports of interest to me.
`9000` provides a media application that can interface with their mobile application.
And `554`, which exposes a real-time streaming protocol (RTSP) that allows for remote observation of cameras.
To quickly proxy these ports, we can use our good ole friend `iptables` again.
By executing the following commands, we can successfully route requests from a port on the Raspberry Pi to a port on the client.
Note, `${CLIENT_IP}` should the IP your client obtained.
`${PORT}` would be the port you want to expose.

```
$ sudo iptables -A PREROUTING -t nat -i wlan0 -p tcp --dport ${PORT} -j DNAT --to ${CLIENT_IP}:${PORT}
$ sudo iptables -A FORWARD -p tcp -d ${CLIENT_IP} --dport ${PORT} -j ACCEPT
```

Note that in my case, the RTSP port needed to also be exposed over `udp` for better streaming support.
If you're exposing ports through a Raspberry Pi, you'll need to verify what protocols to expose them over.
Also, don't forget to save your updated IP table rules, otherwise changes will be lost on reboot.

```
$ sudo netfilter-persistent save
```

## Conclusion

That was it.
Once everything was setup, I was able to connect to the real-time stream from my devices and monitor my whole system.
The mobile application also connected to the security system fine and was able to let me configure cloud backups.
While this is where I stop today, I have some more plans for this in the future.
While I don't expect this to become a regular pattern I'll deploy, it was extremely useful to set up in this case.
