variable "common" {
  type = "map"

  default = {
    default.region  = "ap-northeast-1"
    default.project = "terraform-recipes"
  }
}

variable "vpc" {
  type = "map"

  default = {
    default.cidr       = "10.0.0.0/16"
    stg.cidr           = "10.1.0.0/16"
    dev.cidr           = "10.2.0.0/16"
    qa.cidr            = "10.3.0.0/16"
    default.public_1a  = "10.0.1.0/26"
    default.public_1c  = "10.0.1.64/26"
    default.public_1d  = "10.0.1.128/26"
    stg.public_1a      = "10.1.1.0/26"
    stg.public_1c      = "10.1.1.64/26"
    stg.public_1d      = "10.1.1.128/26"
    dev.public_1a      = "10.2.1.0/26"
    dev.public_1c      = "10.2.1.64/26"
    dev.public_1d      = "10.2.1.128/26"
    qa.public_1a       = "10.3.1.0/26"
    qa.public_1c       = "10.3.1.64/26"
    qa.public_1d       = "10.3.1.128/26"
    default.private_1a = "10.0.2.0/26"
    default.private_1c = "10.0.2.64/26"
    default.private_1d = "10.0.2.128/26"
    stg.private_1a     = "10.1.2.0/26"
    stg.private_1c     = "10.1.2.64/26"
    stg.private_1d     = "10.1.2.128/26"
    dev.private_1a     = "10.2.2.0/26"
    dev.private_1c     = "10.2.2.64/26"
    dev.private_1d     = "10.2.2.128/26"
    qa.private_1a      = "10.3.2.0/26"
    qa.private_1c      = "10.3.2.64/26"
    qa.private_1d      = "10.3.2.128/26"
  }
}

variable "ssh_public_key_path" {
  type    = "string"
  default = ""
}

variable "bastion" {
  type = "map"

  default = {
    default.name                        = "bastion"
    default.image_id                    = "ami-e99f4896"
    default.instance_type               = "t2.micro"
    default.associate_public_ip_address = "true"
    default.volume_type                 = "gp2"
    default.volume_size                 = "30"
  }
}

variable "workplace_cidr_blocks" {
  type    = "list"
  default = []
}
