resource "random_password" "token" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  number  = true
}

## SERVER

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

  hostname = "ip-192-168-4-30"
  ip       = "192.168.4.30"
  token    = random_password.token.result
  region   = "mjpitz"
  zone     = "0"
}

## AGENTS

locals {
  server = "https://192.168.4.30:6443"
}

## AGENTS - Zone 1

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

  hostname = "ip-192-168-4-51"
  ip       = "192.168.4.51"
  token    = random_password.token.result
  server   = local.server
  region   = "mjpitz"
  zone     = "1"
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

  hostname = "ip-192-168-4-52"
  ip       = "192.168.4.52"
  token    = random_password.token.result
  server   = local.server
  region   = "mjpitz"
  zone     = "1"
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

  hostname = "ip-192-168-4-53"
  ip       = "192.168.4.53"
  token    = random_password.token.result
  server   = local.server
  region   = "mjpitz"
  zone     = "1"
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

  hostname = "ip-192-168-4-54"
  ip       = "192.168.4.54"
  token    = random_password.token.result
  server   = local.server
  region   = "mjpitz"
  zone     = "1"
}

## AGENTS - Zone 2

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

  hostname = "ip-192-168-4-61"
  ip       = "192.168.4.61"
  token    = random_password.token.result
  server   = local.server
  region   = "mjpitz"
  zone     = "2"
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

  hostname = "ip-192-168-4-62"
  ip       = "192.168.4.62"
  token    = random_password.token.result
  server   = local.server
  region   = "mjpitz"
  zone     = "2"
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

  hostname = "ip-192-168-4-63"
  ip       = "192.168.4.63"
  token    = random_password.token.result
  server   = local.server
  region   = "mjpitz"
  zone     = "2"
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

  hostname = "ip-192-168-4-64"
  ip       = "192.168.4.64"
  token    = random_password.token.result
  server   = local.server
  region   = "mjpitz"
  zone     = "2"
}
