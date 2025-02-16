resource "aws_instance" "Test-01" {
  ami = "test" 
  count = 2
}