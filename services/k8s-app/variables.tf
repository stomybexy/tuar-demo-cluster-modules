variable "name" {
  type        = string
  description = "The name to use for every resource created by this module"
}

variable "image" {
  type        = string
  description = "The docker image to run"
}

variable "container_port" {
  type        = number
  description = "The port the container listens on"
}

variable "replicas" {
  type        = number
  description = "The number of replicas to run"
  default     = 1
}

variable "environment_variables" {
  type        = map(string)
  description = "A map of environment variables to pass to the container"
  default     = {}
}