variable "common" {
  type = "map"

  default = {
    default.region  = "ap-northeast-1"
    default.project = "terraform-recipes"

    dev.region = "ap-northeast-1"
    stg.region = "ap-northeast-1"
    prd.region = "ap-northeast-1"
  }
}

variable "vpc" {
  type = "map"

  default = {
    default.cidr = "10.0.0.0/16"
    stg.cidr     = "10.1.0.0/16"
    dev.cidr     = "10.2.0.0/16"
  }
}
