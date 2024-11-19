#Security Groups
#Public Subnet Group
resource "aws_security_group" "public_subnet_sg" {
  name        = "public-subnet-sg"
  description = "Security group for frontend servers"
  vpc_id      = aws_vpc.Production_vpc.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-subnet-sg"
  }
}
#private Subnet Group 
# Security Groups
resource "aws_security_group" "private_subnet_sg" {
  name        = "private-subnet-sg"
  description = "Security group for frontend servers"
  vpc_id      = aws_vpc.production_vpc.id

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
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5463
    to_port     = 5463
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-subnet-sg"
  }
}

#Availability Zone 1 
#Bastion Host/ App Server

# Create an EC2 instance in AWS. This resource block defines the configuration of the instance.
resource "aws_instance" "ecommerce_bastion_az1"  {
  ami               = "ami-0866a3c8686eaeeba"               
   # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
 # Replace this with a valid AMI ID
  instance_type     = var.instance_type              
   # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids =  [aws_security_group.public_subnet_sg.id]        
  # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "az1keypair"               
   # The key pair name for SSH access to the instance.
  subnet_id = aws_subnet.public_subnet_1.id
user_data = base64encode(templatefile("${path.module}/deploy.sh", {
    rds_endpoint = aws_db_instance.main.endpoint,
    docker_user = var.dockerhub_username,
    docker_pass = var.dockerhub_password,
    docker_compose = templatefile("${path.module}/compose.yaml", {
      rds_endpoint = aws_db_instance.main.endpoint
    })
  }))
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_bastion_az1"         
  }
}

#App- AZ1
# Create an EC2 instance in AWS. This resource block defines the configuration of the instance.
resource "aws_instance" "ecommerce_app_az1"  {
  ami               = "ami-0866a3c8686eaeeba"               
   # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
 # Replace this with a valid AMI ID
  instance_type     = var.instance_type              
   # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids =  [aws_security_group.private_subnet_sg.id]        
  # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "az1keypair"               
   # The key pair name for SSH access to the instance.
  subnet_id = aws_subnet.private_subnet_1.id
 user_data = base64encode(templatefile("${path.module}/deploy.sh", {
    rds_endpoint = aws_db_instance.main.endpoint
    docker_user = var.dockerhub_username,
    docker_pass = var.dockerhub_password,
    docker_compose = templatefile("${path.module}/compose.yaml", {
      rds_endpoint = aws_db_instance.main.endpoint
    })
  }))
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_app_az1"         
  }
  depends_on = [
    aws_db_instance.main,
    aws_nat_gateway.main
  ]
}


#Availabilitty Zone 2
#Bastion Host/App Server 2

# Create an EC2 instance in AWS. This resource block defines the configuration of the instance.
resource "aws_instance" "ecommerce_bastion_az2"  {
  ami               = "ami-0866a3c8686eaeeba"               
   # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
 # Replace this with a valid AMI ID
  instance_type     = var.instance_type              
   # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids =  [aws_security_group.public_subnet_sg.id]        
  # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "az2keypair"               
   # The key pair name for SSH access to the instance.
  subnet_id = aws_subnet.public_subnet_2.id
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_bastion_az2"         
  }
}

#App- AZ1
# Create an EC2 instance in AWS. This resource block defines the configuration of the instance.
resource "aws_instance" "ecommerce_app_az2"  {
  ami               = "ami-0866a3c8686eaeeba"               
   # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
 # Replace this with a valid AMI ID
  instance_type     = var.instance_type              
   # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids =  [aws_security_group.private_subnet_sg.id]        
  # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "az2keypair"               
   # The key pair name for SSH access to the instance.
  subnet_id = aws_subnet.private_subnet_2.id
  user_data = base64encode(templatefile("${path.module}/deploy.sh", {
    rds_endpoint = aws_db_instance.rds_endp
    docker_user = var.dockerhub_username,
    docker_pass = var.dockerhub_password,
    docker_compose = templatefile("${path.module}/compose.yaml", {
      rds_endpoint = aws_db_instance.main.endpoint
    })
  }))
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_app_az2"         
  }
   depends_on = [
    aws_db_instance.main,
    aws_nat_gateway.main
  ]
}


