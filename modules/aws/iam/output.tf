output "iam" {
  value = "${
    map(
      "webserver_instance_profile_name", "${aws_iam_instance_profile.webserver_instance_profile.name}"
    )
  }"
}
