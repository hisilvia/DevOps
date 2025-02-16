provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "test" {
  ami = var.ami_value
  subnet_id = var.subnet_id_value
  instance_type = var.instance_type_value
}

