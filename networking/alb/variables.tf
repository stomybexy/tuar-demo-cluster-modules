variable "alb_name" {
  type        = string
  description = "Name of the ALB"
}

variable "subnet_ids" {
  description = "The IDs of the subnets to use for the cluster"
  type        = list(string)
}
