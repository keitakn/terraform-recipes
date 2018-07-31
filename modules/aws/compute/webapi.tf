resource "aws_security_group" "webapi" {
  name        = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
  description = "Security Group to ${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webapi_alb" {
  name        = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}-alb"
  description = "Security Group to WebAPI ALB"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}-alb"
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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

resource "aws_launch_configuration" "webapi" {
  name_prefix                 = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}-"
  image_id                    = "${lookup(var.webapi, "${terraform.env}.ami", var.webapi["default.ami"])}"
  instance_type               = "${lookup(var.webapi, "${terraform.env}.instance_type", var.webapi["default.instance_type"])}"
  key_name                    = "${aws_key_pair.ssh_key_pair.id}"
  associate_public_ip_address = false

  root_block_device {
    volume_type = "${lookup(var.webapi, "${terraform.env}.volume_type", var.webapi["default.volume_type"])}"
    volume_size = "${lookup(var.webapi, "${terraform.env}.volume_size", var.webapi["default.volume_size"])}"
  }

  iam_instance_profile = "${lookup(var.iam, "webserver_instance_profile_name")}"
  security_groups      = ["${aws_security_group.webapi.id}"]

  enable_monitoring = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket" "webapi_logs" {
  bucket        = "${terraform.workspace}-${lookup(var.common, "${terraform.env}.project", var.common["default.project"])}-webapi-alb-logs"
  policy        = "${data.aws_iam_policy_document.put_alb_logs.json}"
  force_destroy = true
}

data "aws_elb_service_account" "alb_log" {}

data "aws_iam_policy_document" "put_alb_logs" {
  "statement" {
    actions = ["s3:PutObject"]

    principals {
      identifiers = ["${data.aws_elb_service_account.alb_log.id}"]
      type        = "AWS"
    }

    resources = [
      "arn:aws:s3:::${terraform.workspace}-${lookup(var.common, "${terraform.env}.project", var.common["default.project"])}-webapi-alb-logs/*",
    ]
  }
}

resource "aws_alb" "webapi_alb" {
  name            = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}-alb"
  internal        = false
  security_groups = ["${aws_security_group.webapi_alb.id}"]

  subnets = [
    "${var.vpc["subnet_public_1a"]}",
    "${var.vpc["subnet_public_1c"]}",
    "${var.vpc["subnet_public_1d"]}",
  ]

  access_logs {
    bucket = "${aws_s3_bucket.webapi_logs.bucket}"
  }

  tags {
    Name = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}-alb"
  }
}

resource "aws_alb_target_group" "webapi_target_group" {
  name     = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${lookup(var.vpc, "vpc_id")}"

  health_check {
    interval            = 30
    path                = "/v1/health-checks"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_listener" "webapi_listener" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.webapi_target_group.arn}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_alb.webapi_alb.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${lookup(var.acm, "main_arn")}"
}

resource "aws_autoscaling_group" "webapi_autoscaling_group" {
  vpc_zone_identifier = [
    "${var.vpc["subnet_private_1a"]}",
    "${var.vpc["subnet_private_1c"]}",
    "${var.vpc["subnet_private_1d"]}",
  ]

  name                      = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  desired_capacity          = 1
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.webapi.name}"

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}-${lookup(var.webapi, "${terraform.env}.name", var.webapi["default.name"])}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group_attachment" "webapi_alb_attachment" {
  target_group_arn = "${aws_alb_target_group.webapi_target_group.arn}"
  target_id        = "${aws_instance.webapi.id}"
}

data "aws_route53_zone" "webapi" {
  name = "${var.main_domain_name}"
}

resource "aws_route53_record" "webapi" {
  name    = "${terraform.workspace}-${var.webapi_domain_name}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.webapi.zone_id}"

  alias {
    evaluate_target_health = false
    name                   = "${aws_alb.webapi_alb.dns_name}"
    zone_id                = "${aws_alb.webapi_alb.zone_id}"
  }
}
