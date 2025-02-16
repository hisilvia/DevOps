variable "region_name" {
    type = string
    description = "Region where EC2 will get created"
    default = "ca-central-l"    //from practice.tf line2 region = "ca-central-l"
  
}

variable "instance_type"{
    type = string
    description = "Which type of EC2 you want to create?"

    //only t2.micro or t3.small should be created
    //if(instance_type == "t2.micro" || instance_type == "t3.small")

    validation {
      condition = var.instance_type == "t2.micro" || var.instance_type == "t3.small"
      error_message = "Value entered is not correct. Its should be either t2.micro or t3.small"
    }
}

variable "volumn-size" {
    type = number
    default = 15
  
}