variable "cluster_name" {
  type    = string
  default = "tuar-asg-example"
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances"
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}
