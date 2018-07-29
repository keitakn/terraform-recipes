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
