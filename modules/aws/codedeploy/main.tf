data "aws_iam_policy_document" "codedeploy_trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "codedeploy.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name               = "${terraform.workspace}-codedeploy-role"
  assume_role_policy = "${data.aws_iam_policy_document.codedeploy_trust_relationship.json}"
}

resource "aws_iam_policy_attachment" "codedeploy_role_attachment" {
  name       = "${aws_iam_role.codedeploy_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  roles      = ["${aws_iam_role.codedeploy_role.name}"]
}

resource "aws_codedeploy_app" "webapi" {
  name = "${terraform.workspace}-${var.webapi_codedeploy_app_name}"
}

resource "aws_codedeploy_deployment_group" "webapi_inplace_deploy" {
  app_name               = "${aws_codedeploy_app.webapi.name}"
  deployment_group_name  = "inplace"
  service_role_arn       = "${aws_iam_role.codedeploy_role.arn}"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  lifecycle {
    ignore_changes = ["*"]
  }
}

resource "aws_s3_bucket" "webapi_deploy_bucket" {
  bucket        = "${terraform.workspace}-${var.webapi_deploy_bucket_name}"
  force_destroy = true
}

resource "aws_codedeploy_app" "web" {
  name = "${terraform.workspace}-${var.web_codedeploy_app_name}"
}

resource "aws_codedeploy_deployment_group" "web_inplace_deploy" {
  app_name               = "${aws_codedeploy_app.web.name}"
  deployment_group_name  = "inplace"
  service_role_arn       = "${aws_iam_role.codedeploy_role.arn}"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  lifecycle {
    ignore_changes = ["*"]
  }
}

resource "aws_s3_bucket" "web_deploy_bucket" {
  bucket        = "${terraform.workspace}-${var.web_deploy_bucket_name}"
  force_destroy = true
}
