output "common" {
  value = "${module.vpc.common}"
}

output "vpc" {
  value = "${module.vpc.vpc}"
}

output "bastion" {
  value = "${module.compute.bastion}"
}
