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
  name = "${terraform.workspace}-webapi"
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
