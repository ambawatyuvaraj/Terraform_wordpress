
data "aws_vpc" "vpc-available" {
  filter {
    name   = "tag:Name"
    values = ["web-vpc"]
  }
}

data "aws_subnets" "subnet-available" {
  #vpc_id = data.aws_vpc.vpc-available.id
  filter {
    name   = "tag:Name"
    values = ["web-private-*"]
  }

}

data "aws_availability_zones" "az-available" {
  state = "available"
}

data "aws_security_group" "sg-available" {
  filter {
    name   = "tag:Name"
    values = ["web-sg"]
  }

}
