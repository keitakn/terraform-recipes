data "aws_iam_policy_document" "webserver_trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "webserver_policy" {
  "statement" {
    effect = "Allow"

    actions = [
      "s3:*",
      "codedeploy:Batch*",
      "codedeploy:CreateDeployment",
      "codedeploy:Get*",
      "codedeploy:List*",
      "codedeploy:RegisterApplicationRevision",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "webserver_role" {
  name               = "${terraform.workspace}-webserver-default-role"
  assume_role_policy = "${data.aws_iam_policy_document.webserver_trust_relationship.json}"
}

resource "aws_iam_role_policy" "webserver_role_policy" {
  name   = "${terraform.workspace}-webserver-default-role-policy"
  role   = "${aws_iam_role.webserver_role.id}"
  policy = "${data.aws_iam_policy_document.webserver_policy.json}"
}

resource "aws_iam_instance_profile" "webserver_instance_profile" {
  name = "${terraform.workspace}-webserver-instance-profile"
  role = "${aws_iam_role.webserver_role.name}"
}
