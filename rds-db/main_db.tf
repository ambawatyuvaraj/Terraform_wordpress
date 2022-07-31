resource "aws_db_instance" "web-rds" {
  allocated_storage = 10
  engine            = "mysql"
  #engine_version       = "5.7"
  instance_class = "db.t2.micro"
  db_name        = "webrds"
  username       = "admin"
  password       = "password"
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot      = true
  delete_automated_backups = true
  publicly_accessible      = false
  multi_az                 = false
  db_subnet_group_name     = aws_db_subnet_group.web-rds-subnet-group.id
  vpc_security_group_ids   = [data.aws_security_group.sg-available.id]

}