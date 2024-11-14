#VPC Block

resource "aws_vpc" "production_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Production_VPC"
  }
}

#Subnet Block
#Public Subnet

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2"
  }
}

#PrivateSubnet

resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Private Subnet 1"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Private Subnet 2"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "production_igw"
  }
}