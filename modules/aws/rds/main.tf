resource "aws_db_subnet_group" "rds_subnet" {
  name        = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  description = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-subnet"
  subnet_ids  = ["${lookup(var.vpc, "subnet_private_1a")}", "${lookup(var.vpc, "subnet_private_1c")}", "${lookup(var.vpc, "subnet_private_1d")}"]
}

resource "aws_db_parameter_group" "database_parameter_group" {
  name   = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  family = "aurora-mysql5.7"

  description = "Database parameter group"

  parameter {
    name  = "long_query_time"
    value = "0.1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
}
