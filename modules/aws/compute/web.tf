resource "aws_security_group" "web" {
  name        = "${terraform.workspace}-${lookup(var.web, "${terraform.env}.name", var.web["default.name"])}"
  description = "Security Group to ${lookup(var.web, "${terraform.env}.name", var.web["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.web, "${terraform.env}.name", var.web["default.name"])}"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_alb" {
  name        = "${terraform.workspace}-${lookup(var.web, "${terraform.env}.name", var.web["default.name"])}-alb"
  description = "Security Group to Web ALB"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.web, "${terraform.env}.name", var.web["default.name"])}-alb"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "web_alb_allow_https_from_all" {
  count             = "${terraform.workspace == "prd" ? 1 : 0}"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.web_alb.id}"
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_alb_allow_https_from_workplace" {
  count             = "${terraform.workspace != "prd" ? 1 : 0}"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.web_alb.id}"
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = "${var.workplace_cidr_blocks}"
}

resource "aws_security_group_rule" "web_alb_allow_https_from_nat" {
  count             = "${terraform.workspace != "prd" ? 1 : 0}"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.web_alb.id}"
  to_port           = 443
  type              = "ingress"

  cidr_blocks = [
    "${lookup(var.vpc, "nat_ip_1a")}/32",
    "${lookup(var.vpc, "nat_ip_1c")}/32",
    "${lookup(var.vpc, "nat_ip_1d")}/32",
  ]
}
