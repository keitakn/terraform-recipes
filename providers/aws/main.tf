module "vpc" {
  source = "../../modules/aws/vpc"
  common = "${var.common}"
  vpc    = "${var.vpc}"
  rds    = "${module.rds.rds}"
}

module "compute" {
  source                = "../../modules/aws/compute"
  common                = "${var.common}"
  vpc                   = "${module.vpc.vpc}"
  iam                   = "${module.iam.iam}"
  acm                   = "${module.acm.acm}"
  bastion               = "${var.bastion}"
  builder               = "${var.builder}"
  workplace_cidr_blocks = "${var.workplace_cidr_blocks}"
  ssh_public_key_path   = "${var.ssh_public_key_path}"
  web                   = "${var.web}"
  webapi                = "${var.webapi}"
  web_domain_name       = "${var.web_domain_name}"
  webapi_domain_name    = "${var.webapi_domain_name}"
  main_domain_name      = "${var.main_domain_name}"
}

module "rds" {
  source                       = "../../modules/aws/rds"
  rds                          = "${var.rds}"
  common                       = "${var.common}"
  vpc                          = "${module.vpc.vpc}"
  rds_master_username          = "${var.rds_master_username}"
  rds_master_password          = "${var.rds_master_password}"
  rds_local_domain_base_name   = "${var.rds_local_domain_base_name}"
  rds_local_master_domain_name = "${var.rds_local_master_domain_name}"
  rds_local_slave_domain_name  = "${var.rds_local_slave_domain_name}"
}

module "iam" {
  source = "../../modules/aws/iam"
}

module "acm" {
  source           = "../../modules/aws/acm"
  main_domain_name = "${var.main_domain_name}"
}

module "codedeploy" {
  source                    = "../../modules/aws/codedeploy"
  webapi_deploy_bucket_name = "${var.webapi_deploy_bucket_name}"
}
