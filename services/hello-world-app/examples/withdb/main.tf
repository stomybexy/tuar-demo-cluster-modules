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


module "db" {
  source      = "../../../../datastores/mysql/module"
  id_prefix   = "test"
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}


module "app" {
  source             = "../../module"
  // Pass all the outputs from the mysql module straight through!
  db_config          = module.db
  enable_autoscaling = false
  environment        = var.environment
  instance_type      = "t2.micro"
  max_size           = 1
  min_size           = 1
  greeting           = var.greeting
}

output "server_url" {
  value       = "http://${module.app.dns_name}"
  description = "The URL of the server."
}

output "db_address" {
  value       = module.db.db_address
  description = "The address of the database."
}
