provider "aws" {
    //region = "ca-central-1"
    region = var.region_name

}

resource "aws_instance" "demo" {
    ami = "ami-03fd334507439f4d1"
    instance_type = "t2.micro"
    tags ={
        Name = "ExampleInstance"
    }

    root_block_device {
      delete_on_termination = true
      volume_size = 12
      volume_type = "gp2"
    }
}