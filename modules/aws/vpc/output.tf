output "vpc" {
  value = "${
    map(
      "vpc_id", "${aws_vpc.vpc.id}"
    )
  }"
}

output "common" {
  value = "${var.common}"
}
