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
  cidr_block = "10.0.2.0/24"
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
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 1"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 2"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "production_igw" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "production_igw"
  }
}
# Elastic IP for NAT Gateway in AZ1 and AZ2
resource "aws_eip" "nat_eip_AZ1" {

  tags = {
    Name = "NAT EIP AZ1"
  }
}

resource "aws_eip" "nat_eip_AZ2" {

  tags = {
    Name = "NAT EIP AZ2"
  }
}
#Nat Gateway
resource "aws_nat_gateway" "nat_gw_AZ1" {
  allocation_id = aws_eip.nat_eip_AZ1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "Nat Gateway-AZ1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.production_igw]
}
resource "aws_nat_gateway" "nat_gw_AZ2" {
  allocation_id = aws_eip.nat_eip_AZ2
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "Nat Gateway-AZ2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.production_igw]
}

#Route Tables (Public/Private)

#RouteTable
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}
resource "aws_route_table_association" "public_subnet1_route_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_subnet2_route_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

#Private Route Table 

resource "aws_route_table" "private_route_table_AZ1" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production_igw.id
  }


  tags = {
    Name = "Private Route Table- AZ1"
  }
}

resource "aws_route_table" "private_route_table_AZ2" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production_igw.id
  }


  tags = {
    Name = "Private Route Table- AZ2"
  }
}
resource "aws_route_table_association" "private_route_table_assoc_az1" {
  gateway_id     = aws_nat_gateway.nat_gw_AZ1.id
  route_table_id = aws_route_table.private_route_table_AZ1.id
}

resource "aws_route_table_association" "private_route_table_assoc_az2" {
  gateway_id     = aws_nat_gateway.nat_gw_AZ2.id
  route_table_id = aws_route_table.private_route_table_AZ2.id
}

