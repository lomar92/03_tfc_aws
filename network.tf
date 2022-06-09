resource "aws_vpc" "demo" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "lomar-vpc"
  }
}

resource "aws_subnet" "demo" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = var.subnet_prefix

  tags = {
    name = "webapp-subnet"
  }
}

resource "aws_security_group" "allow_tcp" {
  name = "webapp-security-group"

  vpc_id = aws_vpc.demo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "webapp-security-group"
  }
}

resource "aws_internet_gateway" "ethernet" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "lomar-internet-gateway"
  }
}

resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ethernet.id
  }
}

resource "aws_route_table_association" "demo" {
  subnet_id      = aws_subnet.demo
  route_table_id = aws_route_table.demo.id
}
