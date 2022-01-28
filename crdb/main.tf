locals {
  join = [
    "192.168.4.50",
    "192.168.4.60",
    "192.168.4.70",
  ]
}

module "ip-192-168-4-50" {
  source    = "./node"
  providers = {
    docker = docker.ip-192-168-4-50
  }

  hostname = "ip-192-168-4-50"
  ip       = "192.168.4.50"
  join     = local.join

}

module "ip-192-168-4-60" {
  source    = "./node"
  providers = {
    docker = docker.ip-192-168-4-60
  }

  hostname = "ip-192-168-4-60"
  ip       = "192.168.4.60"
  join     = local.join
}

module "ip-192-168-4-70" {
  source    = "./node"
  providers = {
    docker = docker.ip-192-168-4-70
  }

  hostname = "ip-192-168-4-70"
  ip       = "192.168.4.70"
  join     = local.join
}
