variable "common" {
  type = "map"

  default = {}
}

variable "rds" {
  type = "map"

  default = {}
}

variable "vpc" {
  type = "map"

  default = {}
}

variable "rds_master_username" {
  type    = "string"
  default = ""
}

variable "rds_master_password" {
  type    = "string"
  default = ""
}

variable "rds_local_domain_base_name" {
  type    = "string"
  default = ""
}

variable "rds_local_master_domain_name" {
  type    = "string"
  default = ""
}

variable "rds_local_slave_domain_name" {
  type    = "string"
  default = ""
}
