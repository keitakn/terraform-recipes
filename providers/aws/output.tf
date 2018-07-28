output "common" {
  value = "${module.vpc.common}"
}

output "vpc" {
  value = "${module.vpc.vpc}"
}

output "bastion" {
  value = "${module.compute.bastion}"
}

output "webapi" {
  value = "${module.compute.webapi}"
}

output "rds" {
  value = "${module.rds.rds}"
}

output "iam" {
  value = "${module.iam.iam}"
}

output "acm" {
  value = "${module.acm.acm}"
}
