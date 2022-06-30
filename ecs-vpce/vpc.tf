resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  # for VPC Endpoint
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.project_name}-vpc"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "public-1a"
  }
}

resource "aws_subnet" "public-1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "public-1c"
  }
}

resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "private-1a"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "private-1c"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.project_name}-gw"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public-1a-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-1a.id
}

resource "aws_route_table_association" "public-1c-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-1c.id
}

resource "aws_route_table" "private-1a-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
resource "aws_route_table_association" "private-1a-route-table-association" {
  route_table_id = aws_route_table.private-1a-route-table.id
  subnet_id      = aws_subnet.private-1a.id
}

resource "aws_route_table" "private-1c-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
resource "aws_route_table_association" "private-1c-route-table-association" {
  route_table_id = aws_route_table.private-1c-route-table.id
  subnet_id      = aws_subnet.private-1c.id
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private-1a-route-table.id, aws_route_table.private-1c-route-table.id]
}

# resource "aws_vpc_endpoint" "ssm" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
#   security_group_ids  = [aws_security_group.vpc_endpoint.id]
#   private_dns_enabled = true
# }

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.private-1a.id
  allocation_id = aws_eip.nat.id
}
resource "aws_eip" "nat" {
  vpc = true
}
