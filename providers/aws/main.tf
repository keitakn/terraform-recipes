module "vpc" {
  source = "../../modules/aws/vpc"
  common = "${var.common}"
  vpc    = "${var.vpc}"
}

module "compute" {
  source  = "../../modules/aws/compute"
  common  = "${var.common}"
  vpc     = "${module.vpc.vpc}"
  bastion = "${var.bastion}"
}
