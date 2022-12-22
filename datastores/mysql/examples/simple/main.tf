terraform {
  required_version = ">= 1.2.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1" # Ireland
}

variable "db_password" {
  type        = string
  description = "The password for the master DB user."
  sensitive   = true
}

module "mysql" {
  source            = "../../module"
  id_prefix         = "example"
  db_name           = "simpledb"
  allocated_storage = 5
  db_username       = "root"
  db_password       = var.db_password
}

output "db_host" {
  value = module.mysql.db_address
}

output "db_port" {
  value = module.mysql.db_port
}