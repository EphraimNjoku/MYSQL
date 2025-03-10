provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Create a security group for MySQL
resource "aws_security_group" "mysql_sg" {
  name_prefix = "mysql-sg-"

  # Allow inbound MySQL traffic (port 3306)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to restrict access
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the MySQL RDS instance
resource "aws_db_instance" "mysql_db" {
  identifier           = "migration-project-db"
  engine              = "mysql"
  engine_version      = "8.0"  # Change to your preferred version
  instance_class      = "db.t3.micro"  # Change based on your needs
  allocated_storage   = 20  # Storage size in GB
  username           = "admin"  # Change as needed
  password           = "SecurePassword123!"  # Change and use AWS Secrets Manager in production
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true  # Set to false if you want a final snapshot

  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
}
