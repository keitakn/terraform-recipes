resource "aws_security_group" "webapi" {
  name        = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
  description = "Security Group to ${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ssh_from_bastion" {
  security_group_id        = "${aws_security_group.webapi.id}"
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.bastion.id}"
}
