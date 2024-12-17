variable "project_id" {
  type        = string
  description = "The name of the GCP project"
}

variable "alias_name" {
  type        = string
  description = "The alias to use for naming dependent objects, such as service accounts, for the instance to avoid name/length conflicts"
  default     = ""
}

variable "display_name" {
  type        = string
  description = "The display name of the instance"
  default     = ""
}

variable "name" {
  type        = string
  description = "The name of the instance"
}

variable "labels" {
  type        = map(string)
  description = "Instance labels"
  default     = {}
}

variable "edition" {
  type        = string
  description = "The instance's configuration (e.g. regional-us-central1, regional-europe-west1, regional-asia-east1, multi-regional-us)"
  default     = "ENTERPRISE"
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
variable "autoscale_enabled" {
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

variable "autoscale_max_size" {
  type        = number
  default     = 2000
  description = "Maximum size that the spanner instance can be scaled out to."
}

variable "autoscale_method" {
  type        = string
  default     = "LINEAR"
  description = "Algorithm that should be used to manage the scaling of the spanner instance: STEPWISE, LINEAR, DIRECT"
}

variable "autoscale_min_size" {
  type        = number
  default     = 100
  description = "Minimum size that the spanner instance can be scaled in to."
}

variable "autoscale_schedule" {
  type    = string
  default = "*/2 * * * *"
}

# Optional Database Backup
variable "full_backup_enabled" {
  type        = bool
  description = "Enable Spanner Automated Databases Backup for the instance"
  default     = true
}

# Optional Database Incremental Backup
variable "incremental_backup_enabled" {
  description = "Enable Incremental Backups on Spanner"
  type        = bool
  default     = false
}

variable "backup_expire_time" {
  description = "Seconds until the backup expires"
  type        = string
  default     = "604800s" # 3 days, needs the 's' at the end
}

variable "backup_schedule" {
  description = "The Backup Schedule in CRON format"
  type        = string
  default     = "0 0 * * *"
}

variable "incremental_schedule" {
  description = "The Incremental Backup Schedule in CRON format"
  type        = string
  default     = "0 0 * * *"  
}

variable "backup_schedule_name" {
  type        = string
  default     = ""
  description = "Override the name used for the schedule.  Useful if the generated name is too long or has a conflict."
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

variable "autoscale_cpu_utilization" {
  description = "What percentage of CPU utilization should trigger autoscaling"
  type        = number
  default     = 75
}

variable "autoscale_storage_utilization" {
  description = "What percentage of storage utilization should trigger autoscaling"
  type        = number
  default     = 90
}

variable "pam_access" {
  type = map(object({
    name         = string
    role         = string
    max_time     = string
    auto_approve = bool
    requesters   = list(string)
    approvers    = optional(list(string)) # Required if auto_approve is true
  }))
  default = {}
}
