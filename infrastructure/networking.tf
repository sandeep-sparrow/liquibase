locals {
  common_tags = {
    ManagedBy  = "Microarch"
    Project    = "aws-ecs-redis-rds"
    CostCenter = "sandeep.prajapati - liquibase"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.common_tags, {
    Name = "aws-ecs-redis-rds"
  })
}

resource "aws_subnet" "public_x" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Name = "aws-ecs-redis-rds-public-a"
  })
}

resource "aws_subnet" "public_y" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "aws-ecs-redis-rds-public-b"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "aws-ecs-redis-rds-main"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(local.common_tags, {
    Name = "aws-ecs-redis-rds-main"
  })
}

resource "aws_route_table_association" "x" {
  subnet_id      = aws_subnet.public_x.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "y" {
  subnet_id      = aws_subnet.public_y.id
  route_table_id = aws_route_table.public.id
}