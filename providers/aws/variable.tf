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
    default.public_1a  = "10.0.0.0/22"
    default.public_1c  = "10.0.4.0/22"
    default.public_1d  = "10.0.8.0/22"
    stg.public_1a      = "10.1.0.0/22"
    stg.public_1c      = "10.1.4.0/22"
    stg.public_1d      = "10.1.8.0/22"
    dev.public_1a      = "10.2.0.0/22"
    dev.public_1c      = "10.2.4.0/22"
    dev.public_1d      = "10.2.8.0/22"
    qa.public_1a       = "10.3.0.0/22"
    qa.public_1c       = "10.3.4.0/22"
    qa.public_1d       = "10.3.8.0/22"
    default.private_1a = "10.0.12.0/22"
    default.private_1c = "10.0.16.0/22"
    default.private_1d = "10.0.20.0/22"
    stg.private_1a     = "10.1.12.0/22"
    stg.private_1c     = "10.1.16.0/22"
    stg.private_1d     = "10.1.20.0/22"
    dev.private_1a     = "10.2.12.0/22"
    dev.private_1c     = "10.2.16.0/22"
    dev.private_1d     = "10.2.20.0/22"
    qa.private_1a      = "10.3.12.0/22"
    qa.private_1c      = "10.3.16.0/22"
    qa.private_1d      = "10.3.20.0/22"
  }
}

variable "ssh_public_key_path" {
  type    = "string"
  default = ""
}

variable "bastion" {
  type = "map"

  default = {
    default.name          = "bastion"
    default.ami           = "ami-e99f4896"
    default.instance_type = "t2.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "30"
  }
}

variable "workplace_cidr_blocks" {
  type    = "list"
  default = []
}

variable "builder" {
  type = "map"

  default = {
    default.name          = "builder"
    default.ami           = "ami-9c9443e3"
    default.instance_type = "t2.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "30"
  }
}

variable "web" {
  type = "map"

  default = {
    default.name          = "web"
    default.ami           = "ami-9c9443e3"
    default.instance_type = "t2.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "30"
    stg.ami               = "ami-0cf1c43bdcd7f7898"
    stg.instance_type     = "t2.micro"
  }
}

variable "webapi" {
  type = "map"

  default = {
    default.name          = "webapi"
    default.ami           = "ami-9c9443e3"
    default.instance_type = "t2.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "30"
    stg.ami               = "ami-0f8aa99e6315aabf1"
    stg.instance_type     = "t2.micro"
  }
}

variable "rds" {
  type = "map"

  default = {
    default.name           = "database"
    default.engine         = "aurora-mysql"
    default.engine_version = "5.7.12"
    default.instance_class = "db.r4.large"
    stg.instance_class     = "db.t2.small"
    dev.instance_class     = "db.t2.small"
    qa.instance_class      = "db.r4.large"
    default.instance_count = 3
    stg.instance_count     = 2
    dev.instance_count     = 1
    qa.instance_count      = 3
  }
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

variable "main_domain_name" {
  type = "string"

  default = ""
}

variable "web_domain_name" {
  type = "string"

  default = ""
}

variable "webapi_domain_name" {
  type = "string"

  default = ""
}
