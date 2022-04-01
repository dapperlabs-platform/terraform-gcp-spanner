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

variable "databases" {
  description = "A list of databases to be created"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
}

variable "database_iam" {
  type = map(object({
    role          = string
    database_name = string
    members       = list(string)
  }))
}

# Database Backup
variable "enable_automated_backup" {
  type = bool
  description = "Enable Spanner Automated Database Backup"
  default = false
}

variable "database_ids" {
  type        = set(string)
  description = "Spanner databases you want to backup"
}

variable "gcp_project_id" {
  type = string
  description = "GCP project in which the spanner instance exist"
}

variable "location" {
  type        = string
  description = "Location for App Engine"
}

variable "pubsub_topic" {
  type = string
}

variable "region" {
  type = string
}

variable "spanner_instance_id" {
  type        = string
  description = "Spanner Instance ID where you database is located that you want to backup"
}
