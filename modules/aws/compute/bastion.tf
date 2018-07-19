resource "aws_security_group" "bastion" {
  name        = "${terraform.workspace}-${lookup(var.bastion, "${terraform.env}.name", var.bastion["default.name"])}"
  description = "Security Group to ${lookup(var.bastion, "${terraform.env}.name", var.bastion["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.bastion, "${terraform.env}.name", var.bastion["default.name"])}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ssh_from_workplace" {
  security_group_id = "${aws_security_group.bastion.id}"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = "${var.workplace_cidr_blocks}"
}
