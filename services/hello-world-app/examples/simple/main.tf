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
  description = "The password for the root DB user."
  type        = string
  sensitive   = true
}

variable "instance_type" {
  description = "The type of instance to use."
  type        = string
  default     = "t2.micro"
}

module "db" {
  source      = "../../../../datastores/mysql/module"
  id_prefix   = "hello-app-"
  db_name     = "hello_app_db"
  db_username = "root"
  db_password = var.db_password
}

module "app" {
  source             = "../../module"
  db_address         = module.db.db_address
  db_port            = module.db.db_port
  enable_autoscaling = false
  environment        = "test"
  instance_type      = var.instance_type
  max_size           = 1
  min_size           = 1
  greeting           = "Hello Buddy! What a wonderful time to be an entrepreneur!"
}

output "server_url" {
  value       = "http://${module.app.dns_name}"
  description = "The URL of the server."
}
