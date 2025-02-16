resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  #Inbound for all instances
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Inbound for all instances
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #Inbound for backend app without k8
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #Inbound for backend app with k8
  ingress {
    from_port = 30008
    to_port = 30008
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #Inbound for frontend app without k8
  ingress {
    from_port = 4200
    to_port = 4200
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #Inbound for backend app with k8
  ingress {
    from_port = 30001
    to_port = 30001
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #Inbound for master kubernetes
  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #Inbound for worker nodes for kubernetes
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #Inbund for kubernetes API
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound for all instance
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "my_security_group"
  }
}