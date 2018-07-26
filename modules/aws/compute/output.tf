output "bastion" {
  value = "${
    map(
      "security_group_id", "${aws_security_group.bastion.id}",
      "ssh_key_pair_id", "${aws_key_pair.ssh_key_pair.id}",
      "bastion_ip_1d_1", "${aws_eip.bastion_ip_1d_1.public_ip}",
      "webserver_instance_profile", "${aws_iam_instance_profile.webserver_instance_profile.name}"
    )
  }"
}

output "webapi" {
  value = "${
    map(
      "instance_security_group_id", "${aws_security_group.webapi.id}"
    )
  }"
}
