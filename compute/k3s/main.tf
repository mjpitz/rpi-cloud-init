terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check = true
    endpoint = "https://nyc3.digitaloceanspaces.com"
    region = "us-east-1"
    bucket = "mya-tfstate"
    key = "infra/home/compute/k3s/terraform.tfstate"
  }
}

resource "random_password" "token" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  number  = true
}

locals {
  server = "https://192.168.4.30:6443"

  k3s_server_image = "${var.k3s_image}:${var.k3s_server_tag}"
  k3s_agent_image  = "${var.k3s_image}:${var.k3s_agent_tag}"

  region = "mya"
  zone_0 = "mya-0"
  zone_1 = "mya-1"
  zone_2 = "mya-2"
}
