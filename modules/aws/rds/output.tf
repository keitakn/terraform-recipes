output "rds" {
  value = "${
    map(
      "rds_subnet_group_id", "${aws_db_subnet_group.rds_subnet.id}",
      "endpoint", "${aws_rds_cluster.rds_cluster.endpoint}",
      "reader_endpoint", "${aws_rds_cluster.rds_cluster.reader_endpoint}"
    )
  }"
}
