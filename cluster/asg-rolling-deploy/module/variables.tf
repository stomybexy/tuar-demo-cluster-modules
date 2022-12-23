variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type to use for the cluster (e.g. t2.micro)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of nodes in the cluster"
  type        = number

  validation {
    condition     = var.min_size >= 1
    error_message = "The minimum size must be at least 1, or we'll have an outage."
  }
  validation {
    condition     = var.min_size <= 10
    error_message = "ASG size must be less than 10 to keep costs down."
  }
}

variable "max_size" {
  description = "The maximum number of nodes in the cluster"
  type        = number

  validation {
    condition     = var.max_size >= 1
    error_message = "The maximum size must be at least 1, or we'll have an outage."
  }
  validation {
    condition     = var.max_size <= 10
    error_message = "ASG size must be less than 10 to keep costs down."
  }
}

variable "enable_autoscaling" {
  description = "Whether to enable autoscaling for the cluster"
  type        = bool
}

variable "subnet_ids" {
  description = "The IDs of the subnets to use for the cluster"
  type        = list(string)
}

variable "ami" {
  description = "The AMI to use for the cluster"
  type        = string
}

variable "server_port" {
  type        = number
  description = "The port the server will listen on"
  default     = 8080
}

variable "target_group_arns" {
  description = "The ARNs of the ELB target groups in which to register the cluster nodes"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to use for the cluster nodes. Either ELB or EC2"
  type        = string
  default     = "EC2"
}

variable "user_data" {
  description = "The user data script to run in each instance at boot time"
  type        = string
  default     = null
}

variable "custom_tags" {
  description = "A map of tags to add to EC2 instances created by ASG"
  type        = map(string)
  default     = {}
}

