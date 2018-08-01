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

resource "aws_subnet" "private_1a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1a", var.vpc["default.private_1a"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}a"

  tags {
    Name = "${terraform.workspace}-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1c", var.vpc["default.private_1c"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}c"

  tags {
    Name = "${terraform.workspace}-private-1c"
  }
}

resource "aws_subnet" "private_1d" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1d", var.vpc["default.private_1d"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}d"

  tags {
    Name = "${terraform.workspace}-private-1d"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  allocation_id = "${aws_eip.nat_ip_1a.id}"
  subnet_id     = "${aws_subnet.public_1a.id}"

  tags {
    Name = "${terraform.workspace}-1a"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  allocation_id = "${aws_eip.nat_ip_1c.id}"
  subnet_id     = "${aws_subnet.public_1c.id}"

  tags {
    Name = "${terraform.workspace}-1c"
  }
}

resource "aws_nat_gateway" "nat_1d" {
  allocation_id = "${aws_eip.nat_ip_1d.id}"
  subnet_id     = "${aws_subnet.public_1d.id}"

  tags {
    Name = "${terraform.workspace}-1d"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_1a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_1a.id}"
  }

  tags {
    Name = "private-rt-1a"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_1c.id}"
  }

  tags {
    Name = "private-rt-1c"
  }
}

resource "aws_route_table" "private_1d" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_1d.id}"
  }

  tags {
    Name = "private-rt-1d"
  }
}

resource "aws_route_table_association" "public_1a" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_1a.id}"
}

resource "aws_route_table_association" "public_1c" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_1c.id}"
}

resource "aws_route_table_association" "public_1d" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_1d.id}"
}

resource "aws_route_table_association" "private_1a" {
  route_table_id = "${aws_route_table.private_1a.id}"
  subnet_id      = "${aws_subnet.private_1a.id}"
}

resource "aws_route_table_association" "private_1c" {
  route_table_id = "${aws_route_table.private_1c.id}"
  subnet_id      = "${aws_subnet.private_1c.id}"
}

resource "aws_route_table_association" "private_1d" {
  route_table_id = "${aws_route_table.private_1d.id}"
  subnet_id      = "${aws_subnet.private_1d.id}"
}

resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name         = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}.compute.internal ${lookup(var.rds, "rds_local_domain_name")}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "${terraform.workspace}"
  }
}

resource "aws_network_acl" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    action     = "allow"
    from_port  = 80
    protocol   = "tcp"
    rule_no    = 100
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action     = "allow"
    from_port  = 443
    protocol   = "tcp"
    rule_no    = 110
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action     = "allow"
    from_port  = 22
    protocol   = "tcp"
    rule_no    = 120
    to_port    = 22
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action     = "allow"
    from_port  = 3389
    protocol   = "tcp"
    rule_no    = 130
    to_port    = 3389
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 1024
    protocol   = "tcp"
    rule_no    = 140
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action     = "allow"
    from_port  = 465
    protocol   = "tcp"
    rule_no    = 150
    to_port    = 465
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  egress {
    action     = "allow"
    from_port  = 80
    protocol   = "tcp"
    rule_no    = 100
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 443
    protocol   = "tcp"
    rule_no    = 110
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 3306
    protocol   = "tcp"
    rule_no    = 120
    to_port    = 3306
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  egress {
    action     = "allow"
    from_port  = 1024
    protocol   = "tcp"
    rule_no    = 130
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 22
    protocol   = "tcp"
    rule_no    = 140
    to_port    = 22
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 465
    protocol   = "tcp"
    rule_no    = 150
    to_port    = 465
    cidr_block = "0.0.0.0/0"
  }

  subnet_ids = [
    "${aws_subnet.public_1a.id}",
    "${aws_subnet.public_1c.id}",
    "${aws_subnet.public_1d.id}",
  ]

  tags {
    Name = "${terraform.workspace}-public"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    action     = "allow"
    from_port  = 80
    protocol   = "tcp"
    rule_no    = 100
    to_port    = 80
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 443
    protocol   = "tcp"
    rule_no    = 110
    to_port    = 443
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 22
    protocol   = "tcp"
    rule_no    = 120
    to_port    = 22
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 3306
    protocol   = "tcp"
    rule_no    = 130
    to_port    = 3306
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 3389
    protocol   = "tcp"
    rule_no    = 140
    to_port    = 3389
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 1024
    protocol   = "tcp"
    rule_no    = 150
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action     = "allow"
    from_port  = 465
    protocol   = "tcp"
    rule_no    = 160
    to_port    = 465
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 587
    protocol   = "tcp"
    rule_no    = 170
    to_port    = 587
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  egress {
    action     = "allow"
    from_port  = 80
    protocol   = "tcp"
    rule_no    = 100
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 443
    protocol   = "tcp"
    rule_no    = 110
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 1024
    protocol   = "tcp"
    rule_no    = 120
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 22
    protocol   = "tcp"
    rule_no    = 130
    to_port    = 22
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 465
    protocol   = "tcp"
    rule_no    = 140
    to_port    = 465
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 587
    protocol   = "tcp"
    rule_no    = 150
    to_port    = 587
    cidr_block = "0.0.0.0/0"
  }

  subnet_ids = [
    "${aws_subnet.private_1a.id}",
    "${aws_subnet.private_1c.id}",
    "${aws_subnet.private_1d.id}",
  ]

  tags {
    Name = "${terraform.workspace}-private"
  }
}
