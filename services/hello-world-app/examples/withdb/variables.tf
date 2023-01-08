variable "environment" {
  type        = string
  description = "The environment to deploy to"
  default     = "test"
}

variable "db_username" {
  type        = string
  description = "The username for the database"
  default     = "root"
}

variable "db_password" {
  type        = string
  description = "The password for the database"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "The name of the database"
  default     = "mydb"
}

variable "greeting" {
  type        = string
  description = "The greeting to use"
  default     = "Hello"
}