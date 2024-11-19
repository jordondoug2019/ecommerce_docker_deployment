output "dockerhub_username" {
  value = var.dockerhub_username
}
output "dockerhub_password" {
value = var.dockerhub_password
}
output "app_az1_id"{
value = aws_instance.ecommerce_app_az1.id
}
output "app_az2_id"{
value = aws_instance.ecommerce_app_az2.id
}