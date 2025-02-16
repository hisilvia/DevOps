#Main vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

#public subnets
resource "aws_subnet" "public_subnet" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.my_vpc.id
    map_public_ip_on_launch = true
    tags = {
      Name = "public-subnet"
    }
  
}

#private subnets
resource "aws_subnet" "private_subnet" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.my_vpc.id
    map_public_ip_on_launch = false
    tags = {
      Name = "private-subnet"
    }
  
}

#internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

#route table
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

#association table
resource "aws_route_table_association" "public_sub" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id = aws_subnet.public_subnet.id
}
