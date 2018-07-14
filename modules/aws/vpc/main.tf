resource "aws_vpc" "vpc" {
  cidr_block           = "${lookup(var.vpc, "${terraform.env}.cidr", var.vpc["default.cidr"])}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${terraform.workspace}-${lookup(var.common, "${terraform.env}.project", var.common["default.project"])}-vpc"
  }
}
