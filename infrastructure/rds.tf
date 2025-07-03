resource "aws_db_instance" "mysql" {
  identifier              = "mysql-free-tier"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t4g.micro"
  db_name                 = "liquibaseapp"
  username                = "username"
  password                = "password"
  publicly_accessible     = true
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_db_subnet_group" "db_subnets" {
  name = "mysql-subnet-group"
  subnet_ids = [aws_subnet.public_x.id,
  aws_subnet.public_y.id]

  tags = {
    Name = "MySQL Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "mysql-free-sg"
  description = "Allow MySQL inbound access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "rds_endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "The endpoint to connect to the MySQL RDS instance"
}
