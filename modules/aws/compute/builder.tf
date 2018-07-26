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

resource "aws_instance" "builder_1d_1" {
  ami                         = "${lookup(var.builder, "${terraform.env}.ami", var.builder["default.ami"])}"
  associate_public_ip_address = false
  instance_type               = "${lookup(var.builder, "${terraform.env}.instance_type", var.builder["default.instance_type"])}"

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "${lookup(var.builder, "${terraform.env}.volume_type", var.builder["default.volume_type"])}"
    volume_size = "${lookup(var.builder, "${terraform.env}.volume_size", var.builder["default.volume_size"])}"
  }

  key_name               = "${aws_key_pair.ssh_key_pair.id}"
  subnet_id              = "${var.vpc["subnet_private_1d"]}"
  vpc_security_group_ids = ["${aws_security_group.builder.id}"]

  tags {
    Name = "${terraform.workspace}-${lookup(var.builder, "${terraform.env}.name", var.builder["default.name"])}-1d-1"
  }

  iam_instance_profile = "${lookup(var.iam, "webserver_instance_profile_name")}"

  lifecycle {
    ignore_changes = [
      "*",
    ]
  }
}
