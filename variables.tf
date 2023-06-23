variable "name" {
  type        = string
  description = "The name of the instance"
}

variable "labels" {
  type        = map(string)
  description = "Instance labels"
  default     = {}
}

variable "instance_iam" {
  type = list(object({
    role    = string
    members = list(string)
  }))
}

variable "processing_units" {
  description = "Processing Units"
  type        = number
  default     = 1000
}

# database_dialect values: GOOGLE_STANDARD_SQL, POSTGRESQL
variable "databases" {
  description = "A list of databases to be created"
  type = list(object({
    name                = string
    charset             = string
    collation           = string
    database_dialect    = optional(string, "GOOGLE_STANDARD_SQL")
    deletion_protection = optional(bool, false)
  }))
}

variable "database_iam" {
  type = map(object({
    role          = string
    database_name = string
    members       = list(string)
  }))
}

variable "config" {
  type        = string
  description = "The name of the instance's configuration (e.g. staging: us-west1, europe-west-1, asia-east2 | prod: nam10, eur5, asia1 | see https://cloud.google.com/spanner/docs/instance-configurations)"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

# Optional Database Backup
variable "backup_enabled" {
  type        = bool
  description = "Enable Spanner Automated Databases Backup for the instance"
  default     = false
}
