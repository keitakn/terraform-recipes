output "vpc" {
  value = "${
    map(
      "vpc_id", "${aws_vpc.vpc.id}",
      "subnet_public_1a", "${aws_subnet.public_1a.id}",
      "subnet_public_1c", "${aws_subnet.public_1c.id}",
      "subnet_public_1d", "${aws_subnet.public_1d.id}"
    )
  }"
}

output "common" {
  value = "${var.common}"
}
