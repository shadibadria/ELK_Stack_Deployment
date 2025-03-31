variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}

output "out_vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "out_public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.public_subnets.*.cidr_block
}

# Setup VPC
resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}


# Setup public subnet
resource "aws_subnet" "public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)
  map_public_ip_on_launch = true # Enable auto-assign public IP

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}


# Setup Internet Gateway
resource "aws_internet_gateway" "public_internet_gateway" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "public_igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_gateway.id
  }
  tags = {
    Name = "public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "dev_proj_1_public_rt_subnet_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
