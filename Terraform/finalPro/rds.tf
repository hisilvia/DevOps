#Call VPC First to get the Subnet IDs
#source = "../vpc"

#Define Subnet Group for RDS Service
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "db-snet"
    subnet_ids = [
        "var.private_subnet_1"
    ]
    tags = {
        Name = "db-subnet"
    }
}

#Define Security Groups for RDS Instances
resource "aws_security_group" "rds-sg" {
    name = "rds-sg"
    vpc_id = ""

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
    Name = "rds-sg"
   }
}

resource "aws_db_instance" "rds" {
  identifier = "Development-rds"
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0.40"
  instance_class = "db.t2.micro"
  backup_retention_period = 7
  publicly_accessible = "true"
  username = "root"
  password = "root"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
  multi_az = "false"
}

output "rds_prod_endpoint" {
  value = aws_db_instance.rds.endpoint
}



