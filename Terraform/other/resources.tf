resource "aws_instance" "example" {
    ami = "ami-***"            #Replace with your desired AMI ID
    instance_type = "t2.micro" #Replace with your instance type

    tags = {
        Name = "Terraform EC2"
    }

    count = 2   #Above will be call two times
}