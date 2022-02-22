terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check = true
    endpoint = "https://nyc3.digitaloceanspaces.com"
    region = "us-east-1"
    bucket = "mya-tfstate"
    key = "infra/home/storage/minio/terraform.tfstate"
  }
}

resource "random_string" "user" {
  length = 32
  special = false
  upper = true
  lower = true
  number = true
}

resource "random_password" "password" {
  length = 32
  special = false
  upper = true
  lower = true
  number = true
}

provider "docker" {
  alias     = "ip-192-168-4-30"
  host      = "tcp://192.168.4.30:2376"
  cert_path = pathexpand("~/.docker/machine/machines/ip-192-168-4-30")
}

module "ip-192-168-4-30" {
  source    = "./node"
  providers = {
    docker = docker.ip-192-168-4-30
  }

  hostname = "ip-192-168-4-30"
  ip       = "192.168.4.30"
  user     = random_string.user.result
  password = random_password.password.result
}
