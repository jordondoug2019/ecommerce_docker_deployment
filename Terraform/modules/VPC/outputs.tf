output "public_subnet_ids" {
  value=[aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "private_subnet_ids" {
  value=[aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

output "dev_vpc_id" {
  value= data.aws_vpc.dev_vpc_id.id 
}
output "production_vpc" {
  value = aws_vpc.production_vpc.id 
  
}