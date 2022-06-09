resource "aws_vpc" "webinar" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "${var.environment}-vpc-${var.region}"
  }
}

resource "aws_subnet" "webinar" {
  vpc_id     = aws_vpc.webinar.id
  cidr_block = var.subnet_prefix

  tags = {
    name = "${var.environment}-subnet"
  }
}

resource "aws_security_group" "webinar" {
  name = "${var.environment}-security-group"

  vpc_id = aws_vpc.webinar.id

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
    Name = "${var.environment}-security-group"
  }
}

resource "aws_internet_gateway" "webinar" {
  vpc_id = aws_vpc.webinar.id

  tags = {
    Name = "${var.environment}-internet-gateway"
  }
}

resource "aws_route_table" "webinar" {
  vpc_id = aws_vpc.webinar.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webinar.id
  }
}

resource "aws_route_table_association" "webinar" {
  subnet_id      = aws_subnet.webinar.id
  route_table_id = aws_route_table.webinar.id
}
