# Provider Part
provider "aws" {
  region = "us-east-1" 
}

# VPC Part
resource "aws_vpc" "vpc-1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-1"
  }
}

# Subnet Part
resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.vpc-1.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a" 
  tags = {
    Name = "PublicSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "MyInternetGateway"
  }
}

# Route Table
resource "aws_route_table" "route-table-1" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "PublicRouteTable"
  }
}

# Route for Internet Access
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.route-table-1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route-table-1.id
}


