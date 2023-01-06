terraform {
  required_version = ">=1.2.0, <2.0.0"
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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "alb" {
  source     = "../../module"
  alb_name   = "terraform-up-and-running"
  subnet_ids = data.aws_subnets.default.ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}