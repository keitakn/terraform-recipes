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
