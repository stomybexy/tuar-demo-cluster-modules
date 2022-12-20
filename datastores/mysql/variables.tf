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
