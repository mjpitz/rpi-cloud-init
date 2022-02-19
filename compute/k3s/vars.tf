variable "k3s_image" {
  type    = string
  default = "rancher/k3s"
}

variable "k3s_server_tag" {
  type = string
}

variable "k3s_agent_tag" {
  type = string
}
