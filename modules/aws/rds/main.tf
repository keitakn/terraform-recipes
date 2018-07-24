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
    name         = "character-set-client-handshake"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}

resource "aws_iam_role" "rds_monitoring" {
  name = "${terraform.workspace}-rds-monitoring"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = "${aws_iam_role.rds_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_security_group" "rds" {
  name        = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  description = "Security Group to ${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "mysql_from_private_subnet" {
  security_group_id = "${aws_security_group.rds.id}"
  type              = "ingress"
  from_port         = "3306"
  to_port           = "3306"
  protocol          = "tcp"

  cidr_blocks = [
    "${lookup(var.vpc, "cidr_block_private_1a")}",
    "${lookup(var.vpc, "cidr_block_private_1c")}",
    "${lookup(var.vpc, "cidr_block_private_1d")}",
  ]
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier              = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-cluster"
  engine                          = "${lookup(var.rds, "${terraform.env}.engine", var.rds["default.engine"])}"
  engine_version                  = "${lookup(var.rds, "${terraform.env}.engine_version", var.rds["default.engine_version"])}"
  master_username                 = "${var.rds_master_username}"
  master_password                 = "${var.rds_master_password}"
  backup_retention_period         = 5
  preferred_backup_window         = "19:30-20:00"
  preferred_maintenance_window    = "wed:20:15-wed:20:45"
  port                            = 3306
  vpc_security_group_ids          = ["${aws_security_group.rds.id}"]
  db_subnet_group_name            = "${aws_db_subnet_group.rds_subnet.name}"
  storage_encrypted               = false
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.database_cluster_parameter_group.name}"
}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  count                   = "${lookup(var.rds, "${terraform.env}.instance_count", var.rds["default.instance_count"])}"
  engine                  = "${lookup(var.rds, "${terraform.env}.engine", var.rds["default.engine"])}"
  engine_version          = "${lookup(var.rds, "${terraform.env}.engine_version", var.rds["default.engine_version"])}"
  identifier              = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-${count.index}"
  cluster_identifier      = "${aws_rds_cluster.rds_cluster.id}"
  instance_class          = "${lookup(var.rds, "${terraform.env}.instance_class", var.rds["default.instance_class"])}"
  db_subnet_group_name    = "${aws_db_subnet_group.rds_subnet.name}"
  db_parameter_group_name = "${aws_db_parameter_group.database_parameter_group.name}"
  monitoring_role_arn     = "${aws_iam_role.rds_monitoring.arn}"
  monitoring_interval     = 60

  tags {
    Name = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-${count.index}"
  }
}

resource "aws_route53_zone" "rds_local_domain_name" {
  name    = "smsc-nsc.${terraform.workspace}"
  vpc_id  = "${lookup(var.vpc, "vpc_id")}"
  comment = "${terraform.workspace} RDS Local Domain"
}
