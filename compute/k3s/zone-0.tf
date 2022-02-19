provider "docker" {
  alias     = "ip-192-168-4-30"
  host      = "tcp://192.168.4.30:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-30")
}

module "ip-192-168-4-30" {
  source    = "./server"
  providers = {
    docker = docker.ip-192-168-4-30
  }

  hostname  = "ip-192-168-4-30"
  ip        = "192.168.4.30"
  token     = random_password.token.result
  region    = local.region
  zone      = local.zone_0
  k3s_image = local.k3s_server_image
}
