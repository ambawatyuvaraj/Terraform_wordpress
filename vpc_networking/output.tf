output "vpc-output" {
    value = [aws_vpc.web-vpc.id, aws_vpc.web-vpc.arn, aws_vpc.web-vpc.cidr_block]
}
