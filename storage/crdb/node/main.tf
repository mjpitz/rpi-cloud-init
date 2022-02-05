resource "docker_container" "crdb" {
  name         = "crdb"
  hostname     = var.hostname
  network_mode = "host"
  image        = "christoofar/cockroachdb-arm64:21.2.3"
  restart      = "unless-stopped"

  command = [
    "start",
    "--insecure", # fix
    "--join=${join(",", var.join)}",
    "--listen-addr=0.0.0.0",
    "--http-addr=0.0.0.0",
    "--advertise-addr=${var.ip}:26257",
    "--store=/data/drive-1",
  ]

  ports {
    internal = 26257
    external = 26257
  }

  ports {
    internal = 8080
    external = 8080
  }

  volumes {
    container_path = "/data/drive-1"
    host_path      = "/data/drive-1"
  }
}
