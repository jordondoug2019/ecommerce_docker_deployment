
#Instance Type Variable
variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}


# Public subnet variable
variable "public_subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}

variable "dockerhub_username" {
  type        = string
  sensitive   = true
}
variable "dockerhub_password" {
  type        = string
  sensitive   = true
}