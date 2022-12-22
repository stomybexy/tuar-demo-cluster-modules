variable "id_prefix" {
  default     = ""
  type        = string
  description = "The prefix to use for the ID of the resource"
}

variable "allocated_storage" {
  default     = 10
  type        = number
  description = "The allocated storage in gigabytes"
}

variable "instance_class" {
  default     = "db.t2.micro"
  type        = string
  description = "The instance class to use"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
  default     = null
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default     = null
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Must be > 0 to enable replication"
  type        = number
  default     = null
}

variable "replicate_source_db" {
  description = "The identifier of the source database to replicate"
  type        = string
  default     = null
}
