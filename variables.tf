variable "random_instance_name" {
  type        = bool
  description = "Sets random suffix at the end of the instance resource name"
  default     = false
}
variable "name" {
  type        = string
  description = "The name of the instance"
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
    database_dialect    = optional(string) # default GOOGLE_STANDARD_SQL
    deletion_protection = optional(bool) # default false
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
  description = "The name of the instance's configuration (similar but not quite the same as a region)"
  default     = "regional-us-central1"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

# Optional Database Backup
variable "enable_automated_backup" {
  type        = bool
  description = "Enable Spanner Automated Databases Backup for the instance"
  default     = false
}

variable "gcp_project_id" {
  type        = string
  description = "GCP project in which the spanner backup exist"
  default     = ""
}

variable "location" {
  type        = string
  description = "Location for App Engine"
  default     = "us-central"
}

variable "pubsub_topic" {
  type    = string
  default = "spanner-scheduled-backup-topic"
}

variable "region" {
  type        = string
  description = "GCP Region"
  default     = "us-central1"
}
