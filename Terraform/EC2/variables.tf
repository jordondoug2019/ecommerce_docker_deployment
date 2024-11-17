
#Instance Type Variable
variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}

#Key Pair Variable 
variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}
# Public subnet variable
variable "public_subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}
