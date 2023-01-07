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

variable "environment" {
  type        = string
  description = "The environment to deploy to"
  default     = "test"
}

variable "db_config" {
  description = "The database configuration."
  type        = object({
    db_address = string
    db_port    = number
  })
  default = {
    db_address = "mock-mysql-db-address"
    db_port    = 3306
  }
}

module "app" {
  source             = "../../module"
  // Pass all the outputs from the mysql module straight through!
  db_config          = var.db_config
  enable_autoscaling = false
  environment        = var.environment
  instance_type      = "t2.micro"
  max_size           = 1
  min_size           = 1
  greeting           = "Hello Dude! What a wonderful time to be an entrepreneur!"
}

output "server_url" {
  value       = "http://${module.app.dns_name}"
  description = "The URL of the server."
}
