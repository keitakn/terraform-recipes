variable "access_key" {}
variable "secret_key" {}
variable "region" {}

terraform {
  required_version = "=0.11.7"
}

provider "aws" {
  version    = "=1.27.0"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "dev" {
  cidr_block = "192.0.0.0/16"

  tags {
    Name = "dev"
  }
}
