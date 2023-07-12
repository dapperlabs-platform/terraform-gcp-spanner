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

# Optional Autoscaling
variable "autoscaling_enabled" {
  type        = bool
  description = "Enable autoscaling for the spanner instance"
  default     = false
}

variable "autoscale_in_cooling_minutes" {
  type        = number
  default     = 30
  description = "Minutes to wait after scaling IN or OUT before a scale IN event can be processed."
}

variable "autoscale_out_cooling_minutes" {
  type        = number
  default     = 2
  description = "Minutes to wait after scaling IN or OUT before a scale OUT event can be processed."
}

variable "autoscaling_method" {
  type        = string
  default     = "LINEAR"
  description = "Algorithm that should be used to manage the scaling of the spanner instance: STEPWISE, LINEAR, DIRECT"
}

variable "autoscaling_schedule" {
  type    = string
  default = "*/2 * * * *"
}

# Optional Database Backup
variable "backup_enabled" {
  type        = bool
  description = "Enable Spanner Automated Databases Backup for the instance"
  default     = true
}
variable "backup_deadline" {
  description = "The deadline for the backup schedule"
  type        = string
  default     = "320s"
}

variable "backup_expire_time" {
  description = "Seconds until the backup expires"
  type        = number
  default     = 86400
}

variable "backup_schedule" {
  description = "The Backup Schedule in CRON format"
  type        = string
  default     = "0 0 * * *"
}

variable "backup_schedule_region" {
  description = "The schedule to be enabled on scheduler to trigger spanner DB backup"
  type        = string
  default     = "us-west1"
}

variable "backup_time_zone" {
  description = "The timezone to be used for the backup schedule"
  type        = string
  default     = "America/Vancouver"
}
