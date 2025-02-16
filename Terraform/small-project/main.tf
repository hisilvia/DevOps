provider "aws" {
    region = "eu-west-1"
}

resource "aws_instance" "nginxsetup" {
  ami = "ami-03fd334507439f4d1"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update
  sudo apt install nginx -y
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF

  tags = {
    Name = "NginxSetup"
  }
}