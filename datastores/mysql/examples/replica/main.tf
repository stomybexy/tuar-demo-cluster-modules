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
  alias  = "primary"
}

provider "aws" {
  region = "eu-west-2" # London
  alias  = "replica"
}

variable "db_password" {
  type        = string
  description = "The password for the master DB user."
  sensitive   = true
}

module "primary" {
  source    = "../../module"
  providers = {
    aws = aws.primary
  }
  id_prefix               = "primary-"
  db_name                 = "availableMySQL"
  db_password             = var.db_password
  db_username             = "root"
  backup_retention_period = 1
}

module "replica" {
  source    = "../../module"
  providers = {
    aws = aws.replica
  }
  id_prefix           = "replica-"
  replicate_source_db = module.primary.db_arn
}

output "db_host" {
  value = module.primary.db_address
}

output "db_port" {
  value = module.primary.db_port
}
