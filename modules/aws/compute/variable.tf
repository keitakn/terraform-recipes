variable "common" {
  type = "map"

  default = {}
}

variable "bastion" {
  type = "map"

  default = {}
}

variable "vpc" {
  type = "map"

  default = {}
}

variable "workplace_cidr_blocks" {
  type    = "list"
  default = []
}

variable "ssh_public_key_path" {
  type    = "string"
  default = ""
}

variable "webapi" {
  type = "map"

  default = {}
}
