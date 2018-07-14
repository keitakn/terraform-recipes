module "vpc" {
  source = "../../modules/aws/vpc"
  common = "${var.common}"
  vpc    = "${var.vpc}"
}
