output "bastion" {
  value = "${
    map(
      "security_group_id", "${aws_security_group.bastion.id}"
    )
  }"
}
