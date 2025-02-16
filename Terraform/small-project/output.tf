output "instance_public_ip" {

  description = "The public IP address "
  value = aws_instance.nginxsetup.public_ip
}