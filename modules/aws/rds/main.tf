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

resource "aws_rds_cluster_parameter_group" "database_cluster_parameter_group" {
  name        = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-cluster"
  family      = "aurora-mysql5.7"
  description = "Cluster parameter group for ${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_bin"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_bin"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}
