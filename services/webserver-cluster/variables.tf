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

variable "server_port" {
  type        = number
  description = "The port the server will listen on"
  default     = 8080
}
