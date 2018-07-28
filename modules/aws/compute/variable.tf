variable "common" {
  type = "map"

  default = {}
}

variable "bastion" {
  type = "map"

  default = {}
}

variable "builder" {
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

variable "iam" {
  type = "map"

  default = {}
}

variable "acm" {
  type = "map"

  default = {}
}

variable "webapi" {
  type = "map"

  default = {}
}

variable "main_domain_name" {
  type = "string"

  default = ""
}

variable "webapi_domain_name" {
  type = "string"

  default = ""
}
