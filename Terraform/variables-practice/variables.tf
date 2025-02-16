variable "noList" {
  #[10,20,30]
  type = list(number)
  default = [ 10, 20, 30 ]
  # type = list(string)
  # default = [ "ca-central-l", "us-east-1", "eu-east-1" ]
}
/*
output "test_variables" {
  value = var.nolist
}
*/
variable "map_list" {
  type = map(number)
  default = {
    "ca-central-l" = 10
    "us-east-1" = 20
    "eu-east-1" = 30
  }
}

variable "employeeList" {
    type = list(object({
      name = string
      employee_id = number 
    }))

    default = [{
      employee_id = 1
      name = "Tester"
     
    },
    {
      employee_id = 2
      name = "Developer"
      
    }]

  
}

locals {
  eq = 2*2

  doubleNumber = [for num in noList : num*2]     #can be called many times in for loop
}
output "test_variables" {
  //value = var.nolist
  //value = var.map_list
  //value = var.employeeList.name
  value = local.eq.doubleNumber
}