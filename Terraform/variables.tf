variable access_key{
    type=string
    sensitive=true
    }        
variable secret_key {
    sensitive = true
}   
variable region{}

variable instance_type{
    default="t3.micro"
}
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
variable "dockerhub_username" {
  type        = string
  sensitive   = true
}
variable "dockerhub_password" {
  type        = string
  sensitive   = true
}

variable "key_name" {
  type=string
}
