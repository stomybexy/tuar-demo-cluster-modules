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

module "asg" {
  source             = "../../module"
  ami                = data.aws_ami.ubuntu.id
  cluster_name       = var.cluster_name
  enable_autoscaling = false
  instance_type      = var.instance_type
  max_size           = var.max_size
  min_size           = var.min_size
  subnet_ids         = data.aws_subnets.default.ids
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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
