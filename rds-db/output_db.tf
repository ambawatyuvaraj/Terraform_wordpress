output "subnet_data" {
  value = data.aws_subnets.subnet-available.ids
}

output "rds_data" {
  value = aws_db_instance.web-rds.address
}