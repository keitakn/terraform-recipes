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

// TODO 最終的にはオートスケールグループが出来るように改修を行う
resource "aws_instance" "webapi" {
  ami                         = "${lookup(var.webapi, "${terraform.env}.ami", var.webapi["default.ami"])}"
  associate_public_ip_address = false
  instance_type               = "${lookup(var.webapi, "${terraform.env}.instance_type", var.webapi["default.instance_type"])}"

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "${lookup(var.webapi, "${terraform.env}.volume_type", var.webapi["default.volume_type"])}"
    volume_size = "${lookup(var.webapi, "${terraform.env}.volume_size", var.webapi["default.volume_size"])}"
  }

  key_name               = "${aws_key_pair.ssh_key_pair.id}"
  subnet_id              = "${var.vpc["subnet_private_1d"]}"
  vpc_security_group_ids = ["${aws_security_group.webapi.id}"]

  tags {
    Name = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}-1d-1"
  }

  lifecycle {
    ignore_changes = [
      "*",
    ]
  }
}
