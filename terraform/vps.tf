# VPC and multi-AZ network layout for EKS
# 2 AZs, each with 1 public + 1 private subnet

data "aws_availability_zones" "available" {
  state = "available"
}

# VPC — /16 gives room for growth across multiple environments
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Required for EKS pod DNS resolution
  enable_dns_support   = true
  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

# Public subnet AZ-a — hosts ALB and NAT Gateway
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${local.name_prefix}-public-a"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private subnet AZ-a — EKS worker nodes, no direct internet access
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name                              = "${local.name_prefix}-private-a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Public subnet AZ-b — HA pair for load balancing
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${local.name_prefix}-public-b"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private subnet AZ-b — multi-AZ redundancy for workloads
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name                              = "${local.name_prefix}-private-b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Internet Gateway — inbound/outbound for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${local.name_prefix}-igw" }
}

# Public route table — sends 0.0.0.0/0 through IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${local.name_prefix}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private route table — sends 0.0.0.0/0 through NAT Gateway
# NOTE: Single NAT GW is a cost trade-off; for full HA, use one NAT per AZ
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = { Name = "${local.name_prefix}-private-rt" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}