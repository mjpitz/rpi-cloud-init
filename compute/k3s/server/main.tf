data "template_file" "config" {
  template = <<EOF
token: ${var.token}
disable:
  - servicelb
  - traefik
node-label:
  - topology.kubernetes.io/region=${var.region}
  - topology.kubernetes.io/zone=${var.zone}
EOF
}

resource "null_resource" "config" {
  depends_on = [
    data.template_file.config,
  ]

  provisioner "local-exec" {
    command = "docker-machine ssh ${var.hostname} \"sudo mkdir -p /etc/rancher/k3s/; echo '${base64encode(data.template_file.config.rendered)}' | base64 --decode | sudo tee /etc/rancher/k3s/config.yaml 1>/dev/null\""
  }
}

resource "docker_container" "k3s" {
  depends_on = [null_resource.config]

  name         = "k3s"
  hostname     = var.hostname
  network_mode = "host"
  image        = "rancher/k3s:v1.23.2-k3s1"
  restart      = "unless-stopped"

  command = [
    "server",
  ]

  publish_all_ports = true

  volumes {
    container_path = "/etc/rancher/k3s"
    host_path      = "/etc/rancher/k3s"
  }

  volumes {
    container_path = "/lib/modules"
    host_path      = "/lib/modules"
  }

  volumes {
    container_path = "/var/lib/rancher/k3s"
    host_path      = "/var/lib/rancher/k3s"
  }

  privileged = true

  tmpfs = {
    "/run" : "",
    "/var/run" : "",
  }
}
