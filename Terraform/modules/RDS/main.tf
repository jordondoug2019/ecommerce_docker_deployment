resource "aws_db_instance" "main" {
  identifier        = "ecommerce-db"
  engine            = "postgres"
  engine_version    = "13.3"  # Use the desired version
  instance_class    = "db.t3.micro"  # Choose an instance class based on your needs
  allocated_storage = 10  # Adjust the storage size as necessary (in GB)
  db_name           = "ecommerce"
  username          = "userdb"
  password          = var.db_password  # Replace with a secure password or use secrets management
  port              = 5432
  multi_az          = false  # Set to true for multi-availability zone deployment
  publicly_accessible = true  # Set to false if you want it to be private

  vpc_security_group_ids = [aws_security_group.private_subnet_sg.id]  # Security group for your DB

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name  # Ensure this subnet group exists

  tags = {
    Name = "EcommerceDB"
    Environment = "Production"
  }

}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "ecommerce-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]  # Define your subnets

  tags = {
    Name = "Ecommerce DB Subnet Group"
  }
}







