module "ec2_module" {
  source = "./modules/ec2_module"
  instance_type_value = "t2.micro"
  ami_value = "ami-03fd334507439f4d1"
  subnet_id_value = "subnet-08b825a2f3132bcb9"
}