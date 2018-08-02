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
