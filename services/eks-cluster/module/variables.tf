variable "name" {
  description = "The name to use for the EKS cluster"
  type        = string
}

variable "min_size" {
  description = "The minimum number of nodes to use for the EKS cluster"
  type        = number
}

variable "max_size" {
  description = "The maximum number of nodes to use for the EKS cluster"
  type        = number
}

variable "desired_size" {
  description = "The desired number of nodes to use for the EKS cluster"
  type        = number
}

variable "instance_types" {
  description = "The types of EC2 instances to run in the node group"
  type        = list(string)
}
