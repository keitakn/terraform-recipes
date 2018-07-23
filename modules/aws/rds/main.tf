resource "aws_db_subnet_group" "rds_subnet" {
  name        = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  description = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-subnet"
  subnet_ids  = ["${lookup(var.vpc, "subnet_private_1a")}", "${lookup(var.vpc, "subnet_private_1c")}", "${lookup(var.vpc, "subnet_private_1d")}"]
}
