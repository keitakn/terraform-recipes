resource "aws_security_group" "builder" {
  name        = "${terraform.workspace}-${lookup(var.builder, "${terraform.env}.name", var.builder["default.name"])}"
  description = "Security Group to ${lookup(var.builder, "${terraform.env}.name", var.builder["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.builder, "${terraform.env}.name", var.builder["default.name"])}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = ["${aws_security_group.bastion.id}"]
  }
}
