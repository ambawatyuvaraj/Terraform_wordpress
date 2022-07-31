resource "aws_vpc" "web-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true 
  enable_dns_support = true
  tags = {
    Name = "web-vpc"
  }
}

resource "aws_subnet" "web-public-subnet-1" {
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "web-subnet-1"
  }
}

resource "aws_subnet" "web-public-subnet-2" {
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "web-subnet-2"
  }
}

resource "aws_subnet" "web-private-subnet-1" {
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "web-private-subnet-1"
  }
}

resource "aws_subnet" "web-private-subnet-2" {
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "web-private-subnet-2"
  }
}


resource "aws_internet_gateway" "web-igw" {
  vpc_id = aws_vpc.web-vpc.id

  tags = {
    Name = "web-igw"
  }
}

resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.web-vpc.id

  route = []

  tags = {
    Name = "web-rt"
  }
}

resource "aws_route" "web-r" {
  route_table_id            = aws_route_table.web-rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.web-igw.id
  depends_on                = [aws_route_table.web-rt]
}

resource "aws_route_table" "web-rds-rt" {
  vpc_id = aws_vpc.web-vpc.id

  tags = {
    Name = "web-rds-rt"
  }
}

resource "aws_route_table_association" "web-a1" {
  subnet_id         = aws_subnet.web-public-subnet-1.id
  route_table_id = aws_route_table.web-rt.id
}

resource "aws_route_table_association" "web-a2" {
  subnet_id         = aws_subnet.web-public-subnet-2.id
  route_table_id = aws_route_table.web-rt.id
}

resource "aws_route_table_association" "web-db-a1" {
  subnet_id         = aws_subnet.web-private-subnet-1.id
  route_table_id = aws_route_table.web-rds-rt.id
}

resource "aws_route_table_association" "web-db-a2" {
  subnet_id         = aws_subnet.web-private-subnet-2.id
  route_table_id = aws_route_table.web-rds-rt.id
}



resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow All inbound traffic"
  vpc_id      = aws_vpc.web-vpc.id

  ingress {
    description = "Allowing all traffic to webapp"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [0.0.0.0/0]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}
