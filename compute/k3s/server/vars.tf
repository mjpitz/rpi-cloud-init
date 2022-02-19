variable "hostname" {
  type = string
}

variable "ip" {
  type = string
}

variable "token" {
  type = string
}

variable "region" {
  type    = string
  default = ""
}

variable "zone" {
  type    = string
  default = ""
}

variable "k3s_image" {
  type = string
}
