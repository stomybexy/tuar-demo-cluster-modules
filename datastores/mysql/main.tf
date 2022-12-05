terraform {
  required_version = ">=1.2.0, <2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

resource "aws_db_instance" "db" {
  identifier_prefix   = "tuar"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
}
