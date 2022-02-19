provider "docker" {
  alias     = "ip-192-168-4-61"
  host      = "tcp://192.168.4.61:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-61")
}

module "ip-192-168-4-61" {
  depends_on = [module.ip-192-168-4-30]

  source    = "./agent"
  providers = {
    docker = docker.ip-192-168-4-61
  }

  hostname  = "ip-192-168-4-61"
  ip        = "192.168.4.61"
  token     = random_password.token.result
  server    = local.server
  region    = local.region
  zone      = local.zone_2
  k3s_image = local.k3s_agent_image
}

provider "docker" {
  alias     = "ip-192-168-4-62"
  host      = "tcp://192.168.4.62:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-62")
}

module "ip-192-168-4-62" {
  depends_on = [module.ip-192-168-4-30]

  source    = "./agent"
  providers = {
    docker = docker.ip-192-168-4-62
  }

  hostname  = "ip-192-168-4-62"
  ip        = "192.168.4.62"
  token     = random_password.token.result
  server    = local.server
  region    = local.region
  zone      = local.zone_2
  k3s_image = local.k3s_agent_image
}

provider "docker" {
  alias     = "ip-192-168-4-63"
  host      = "tcp://192.168.4.63:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-63")
}

module "ip-192-168-4-63" {
  depends_on = [module.ip-192-168-4-30]

  source    = "./agent"
  providers = {
    docker = docker.ip-192-168-4-63
  }

  hostname  = "ip-192-168-4-63"
  ip        = "192.168.4.63"
  token     = random_password.token.result
  server    = local.server
  region    = local.region
  zone      = local.zone_2
  k3s_image = local.k3s_agent_image
}

provider "docker" {
  alias     = "ip-192-168-4-64"
  host      = "tcp://192.168.4.64:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-64")
}

module "ip-192-168-4-64" {
  depends_on = [module.ip-192-168-4-30]

  source    = "./agent"
  providers = {
    docker = docker.ip-192-168-4-64
  }

  hostname  = "ip-192-168-4-64"
  ip        = "192.168.4.64"
  token     = random_password.token.result
  server    = local.server
  region    = local.region
  zone      = local.zone_2
  k3s_image = local.k3s_agent_image
}
