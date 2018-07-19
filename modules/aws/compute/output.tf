output "bastion" {
  value = "${
    map(
      "security_group_id", "${aws_security_group.bastion.id}",
      "ssh_key_pair_id", "${aws_key_pair.ssh_key_pair.id}"
    )
  }"
}
