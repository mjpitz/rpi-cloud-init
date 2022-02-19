provider "docker" {
  alias     = "ip-192-168-4-51"
  host      = "tcp://192.168.4.51:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-51")
}

module "ip-192-168-4-51" {
  depends_on = [module.ip-192-168-4-30]

  source    = "./agent"
  providers = {
    docker = docker.ip-192-168-4-51
  }

  hostname  = "ip-192-168-4-51"
  ip        = "192.168.4.51"
  token     = random_password.token.result
  server    = local.server
  region    = local.region
  zone      = local.zone_1
  k3s_image = local.k3s_agent_image
}

provider "docker" {
  alias     = "ip-192-168-4-52"
  host      = "tcp://192.168.4.52:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-52")
}

module "ip-192-168-4-52" {
  depends_on = [module.ip-192-168-4-30]

  source    = "./agent"
  providers = {
    docker = docker.ip-192-168-4-52
  }

  hostname  = "ip-192-168-4-52"
  ip        = "192.168.4.52"
  token     = random_password.token.result
  server    = local.server
  region    = local.region
  zone      = local.zone_1
  k3s_image = local.k3s_agent_image
}

provider "docker" {
  alias     = "ip-192-168-4-53"
  host      = "tcp://192.168.4.53:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-53")
}

module "ip-192-168-4-53" {
  depends_on = [module.ip-192-168-4-30]

  source    = "./agent"
  providers = {
    docker = docker.ip-192-168-4-53
  }

  hostname  = "ip-192-168-4-53"
  ip        = "192.168.4.53"
  token     = random_password.token.result
  server    = local.server
  region    = local.region
  zone      = local.zone_1
  k3s_image = local.k3s_agent_image
}

provider "docker" {
  alias     = "ip-192-168-4-54"
  host      = "tcp://192.168.4.54:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-54")
}

module "ip-192-168-4-54" {
  depends_on = [module.ip-192-168-4-30]

  source    = "./agent"
  providers = {
    docker = docker.ip-192-168-4-54
  }

  hostname  = "ip-192-168-4-54"
  ip        = "192.168.4.54"
  token     = random_password.token.result
  server    = local.server
  region    = local.region
  zone      = local.zone_1
  k3s_image = local.k3s_agent_image
}
