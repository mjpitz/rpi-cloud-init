terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  alias     = "ip-192-168-4-50"
  host      = "tcp://192.168.4.50:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-50")
}

provider "docker" {
  alias     = "ip-192-168-4-60"
  host      = "tcp://192.168.4.60:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-60")
}

provider "docker" {
  alias     = "ip-192-168-4-70"
  host      = "tcp://192.168.4.70:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-70")
}
