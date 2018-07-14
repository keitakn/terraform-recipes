variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  version    = "=1.27.0"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}"
}
