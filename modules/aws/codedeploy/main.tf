data "aws_iam_policy_document" "codedeploy_policy" {
  "statement" {
    effect = "Allow"

    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DeleteLifecycleHook",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:PutLifecycleHook",
      "autoscaling:RecordLifecycleActionHeartbeat",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:EnableMetricsCollection",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribePolicies",
      "autoscaling:DescribeScheduledActions",
      "autoscaling:DescribeNotificationConfigurations",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:SuspendProcesses",
      "autoscaling:ResumeProcesses",
      "autoscaling:AttachLoadBalancers",
      "autoscaling:PutScalingPolicy",
      "autoscaling:PutScheduledUpdateGroupAction",
      "autoscaling:PutNotificationConfiguration",
      "autoscaling:PutLifecycleHook",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DeleteAutoScalingGroup",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:TerminateInstances",
      "tag:GetTags",
      "tag:GetResources",
      "sns:Publish",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "codedeploy_trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "codedeploy.us-west-2.amazonaws.com",
        "codedeploy.ap-south-1.amazonaws.com",
        "codedeploy.eu-central-1.amazonaws.com",
        "codedeploy.ap-northeast-1.amazonaws.com",
        "codedeploy.ca-central-1.amazonaws.com",
        "codedeploy.us-east-1.amazonaws.com",
        "codedeploy.us-west-1.amazonaws.com",
        "codedeploy.sa-east-1.amazonaws.com",
        "codedeploy.eu-west-2.amazonaws.com",
        "codedeploy.ap-southeast-2.amazonaws.com",
        "codedeploy.eu-west-1.amazonaws.com",
        "codedeploy.us-east-2.amazonaws.com",
        "codedeploy.ap-southeast-1.amazonaws.com",
        "codedeploy.ap-northeast-2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name               = "${terraform.workspace}-codedeploy-role"
  assume_role_policy = "${data.aws_iam_policy_document.codedeploy_trust_relationship.json}"
}

resource "aws_iam_role_policy" "codedeploy_role_policy" {
  name   = "${terraform.workspace}-codedeploy-role-policy"
  role   = "${aws_iam_role.codedeploy_role.id}"
  policy = "${data.aws_iam_policy_document.codedeploy_policy.json}"
}

resource "aws_codedeploy_app" "webapi" {
  name = "${terraform.workspace}-webapi"
}
