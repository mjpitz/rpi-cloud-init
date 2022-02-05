# docker-machine

I treat my laptop as an orchestrator for the nodes of my cluster. To do this, I use docker-machine and connect each 
machine. This provides a few benefits for my home lab, but the biggest of which is convenience. I can easily introspect 
remote machines and docker processes from a single terminal.

```bash
# run to purge the unattended-upgrades script
$ ./docker-machine/purge.sh

$ ./docker-machine/connect.sh
# ...

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
