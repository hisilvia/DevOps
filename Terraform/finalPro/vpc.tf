#Main vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

#public subnet
resource "aws_subnet" "public_subnet_1" {
    cidr_block = "10.0.101.0/24"
    vpc_id = aws_vpc.my_vpc.id
    map_public_ip_on_launch = true
    tags = {
      Name = "public-subnet-1"
    }
  
}


#private subnet 
resource "aws_subnet" "private_subnet_1" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.my_vpc.id
    map_public_ip_on_launch = false
    tags = {
      Name = "private-subnet-1"
    }
  
}


#internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

# Route Table for public Architecture
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

#Route Table association with public subnets
resource "aws_route_table_association" "public_sub" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id = aws_subnet.public_subnet.id
}
