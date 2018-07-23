output "rds" {
  value = "${
    map(
      "rds_subnet_group_id", "${aws_db_subnet_group.rds_subnet.id}"
    )
  }"
}
