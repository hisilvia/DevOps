output "instance_public_ip_frontendapp" {
  description = "The public IP address for the frontendapp"
  value       = aws_instance.frontend_app.public_ip
}

output "instance_public_ip_backendapp" {
  description = "The public IP address for the backendapp"
  value       = aws_instance.backend_app.public_ip
}

output "instance_public_ip_kubernetesmaster" {
  description = "The public IP address for the kubernetesmater"
  value       = aws_instance.kubernetes_master.public_ip
}

output "instance_public_ip_jenkinsserver" {
  description = "The public IP address for the jenkinsserver"
  value       = aws_instance.jenkins_server.public_ip
}

output "instance_public_ip_frontendapp" {
  description = "The public IP address for the frontendapp"
  value       = aws_instance.frontend_app.public_ip
}