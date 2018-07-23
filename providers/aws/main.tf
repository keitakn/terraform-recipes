module "vpc" {
  source = "../../modules/aws/vpc"
  common = "${var.common}"
  vpc    = "${var.vpc}"
}

module "compute" {
  source                = "../../modules/aws/compute"
  common                = "${var.common}"
  vpc                   = "${module.vpc.vpc}"
  bastion               = "${var.bastion}"
  workplace_cidr_blocks = "${var.workplace_cidr_blocks}"
  ssh_public_key_path   = "${var.ssh_public_key_path}"
  webapi                = "${var.webapi}"
}

module "rds" {
  source              = "../../modules/aws/rds"
  rds                 = "${var.rds}"
  common              = "${var.common}"
  vpc                 = "${module.vpc.vpc}"
  rds_master_username = "${var.rds_master_username}"
  rds_master_password = "${var.rds_master_password}"
}
