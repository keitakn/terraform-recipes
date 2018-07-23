output "vpc" {
  value = "${
    map(
      "vpc_id", "${aws_vpc.vpc.id}",
      "subnet_public_1a", "${aws_subnet.public_1a.id}",
      "subnet_public_1c", "${aws_subnet.public_1c.id}",
      "subnet_public_1d", "${aws_subnet.public_1d.id}",
      "subnet_private_1a", "${aws_subnet.private_1a.id}",
      "subnet_private_1c", "${aws_subnet.private_1c.id}",
      "subnet_private_1d", "${aws_subnet.private_1d.id}",
      "cidr_block_public_1a", "${lookup(var.vpc, "${terraform.env}.public_1a", var.vpc["default.public_1a"])}",
      "cidr_block_public_1c", "${lookup(var.vpc, "${terraform.env}.public_1c", var.vpc["default.public_1c"])}",
      "cidr_block_public_1d", "${lookup(var.vpc, "${terraform.env}.public_1d", var.vpc["default.public_1d"])}",
      "cidr_block_private_1a", "${lookup(var.vpc, "${terraform.env}.private_1a", var.vpc["default.private_1a"])}",
      "cidr_block_private_1c", "${lookup(var.vpc, "${terraform.env}.private_1c", var.vpc["default.private_1c"])}",
      "cidr_block_private_1d", "${lookup(var.vpc, "${terraform.env}.private_1d", var.vpc["default.private_1d"])}",
      "nat_ip_1a", "${aws_eip.nat_ip_1a.public_ip}",
      "nat_ip_1c", "${aws_eip.nat_ip_1c.public_ip}",
      "nat_ip_1d", "${aws_eip.nat_ip_1d.public_ip}"
    )
  }"
}

output "common" {
  value = "${var.common}"
}
