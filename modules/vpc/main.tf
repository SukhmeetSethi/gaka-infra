# VPC Resource
resource "aws_vpc" "gaka_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "gaka-vpc-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.gaka_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name        = "gaka-public-subnet-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.gaka_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "gaka-private-subnet-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gaka_igw" {
  vpc_id = aws_vpc.gaka_vpc.id

  tags = {
    Name        = "gaka-igw-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = {
    Name        = "gaka-nat-eip-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# NAT Gateway
resource "aws_nat_gateway" "gaka_nat" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "gaka-nat-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }

  depends_on = [aws_internet_gateway.gaka_igw]
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.gaka_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gaka_igw.id
  }

  tags = {
    Name        = "gaka-public-rt-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.gaka_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gaka_nat[count.index].id
  }

  tags = {
    Name        = "gaka-private-rt-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
} 