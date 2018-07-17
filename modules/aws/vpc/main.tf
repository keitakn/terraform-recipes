resource "aws_vpc" "vpc" {
  cidr_block           = "${lookup(var.vpc, "${terraform.env}.cidr", var.vpc["default.cidr"])}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${terraform.workspace}-${lookup(var.common, "${terraform.env}.project", var.common["default.project"])}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${terraform.workspace}-igw"
  }
}

resource "aws_eip" "nat_ip_1a" {
  tags {
    Name = "${terraform.workspace}-nat-1a"
  }
}

resource "aws_eip" "nat_ip_1c" {
  tags {
    Name = "${terraform.workspace}-nat-1c"
  }
}

resource "aws_eip" "nat_ip_1d" {
  tags {
    Name = "${terraform.workspace}-nat-1d"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1a", var.vpc["default.public_1a"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}a"

  tags {
    Name = "${terraform.workspace}-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1c", var.vpc["default.public_1c"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}c"

  tags {
    Name = "${terraform.workspace}-public-1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1d", var.vpc["default.public_1d"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}d"

  tags {
    Name = "${terraform.workspace}-public-1d"
  }
}
