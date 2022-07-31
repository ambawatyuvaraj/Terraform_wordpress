data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  owners = ["amazon"]
}

data "aws_vpc" "available-vpc" {
  filter {
    name   = "tag:Name"
    values = ["web-vpc"]
  }

}

data "aws_subnets" "available-subnets" {
  filter {
    name   = "tag:Name"
    values = ["web-subnet-*"]
  }

}

data "aws_security_group" "available-sg" {
  filter {
    name   = "tag:Name"
    values = ["web-sg"]
  }
}

data "template_file" "user-data" {
  template = file("./user-data.sh")

}