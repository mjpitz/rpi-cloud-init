resource "docker_container" "minio" {
  name         = "minio"
  hostname     = var.hostname
  network_mode = "host"
  image        = "quay.io/minio/minio:RELEASE.2022-02-01T18-00-14Z"
  restart      = "unless-stopped"

  env = [
    "MINIO_PROMETHEUS_AUTH_TYPE=public",
    "MINIO_CONSOLE_ADDRESS=:9090",
    "MINIO_ROOT_USER=${var.user}",
    "MINIO_ROOT_PASSWORD=${var.password}",
  ]

  command = [
    "server",
    "/data/drive-{0...1}/data{0...1}",
  ]

  ports {
    internal = 9000
    external = 9000
  }

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    container_path = "/data/drive-0"
    host_path      = "/data/minio"
  }

  volumes {
    container_path = "/data/drive-1"
    host_path      = "/data/drive-1"
  }
}
