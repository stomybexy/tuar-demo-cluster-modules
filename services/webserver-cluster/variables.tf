variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "db_address" {
  description = "The address of the database"
  type        = string
}

variable "db_port" {
  description = "The port of the database"
  type        = number
}

variable "instance_type" {
  description = "The EC2 instance type to use for the cluster (e.g. t2.micro)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of nodes in the cluster"
  type        = number
}

variable "max_size" {
  description = "The maximum number of nodes in the cluster"
  type        = number
}

variable "enable_autoscaling" {
  description = "Whether to enable autoscaling for the cluster"
  type        = bool
}

variable "server_port" {
  type        = number
  description = "The port the server will listen on"
  default     = 8080
}

variable "custom_tags" {
  description = "A map of tags to add to EC2 instances created by ASG"
  type        = map(string)
  default     = {}
}

variable "ami" {
  description = "The AMI to use for the cluster"
  type        = string
  default     = "ami-0b24feb030d5e3f22"
}

variable "greeting" {
  description = "The greeting to display"
  type        = string
  default     = "Hello, World!"
}