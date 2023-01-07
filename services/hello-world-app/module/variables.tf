variable "environment" {
  description = "The name of the environment we're deploying into"
  type        = string
}

variable "db_config" {
  description = "The database configuration."
  type        = object({
    db_address = string
    db_port    = number
  })
  default = null
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
  default     = null
}

variable "greeting" {
  description = "The greeting to display"
  type        = string
  default     = "Hello, World!"
}