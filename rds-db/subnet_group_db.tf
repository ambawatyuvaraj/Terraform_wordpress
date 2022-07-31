resource "aws_db_subnet_group" "web-rds-subnet-group" {
  name       = "web-rds-subnet-group"
  subnet_ids = data.aws_subnets.subnet-available.ids
  tags = {
    Name = "web-rds-subnet-group"
  }
}
