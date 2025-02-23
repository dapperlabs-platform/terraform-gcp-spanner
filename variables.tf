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
    name                       = string
    charset                    = string
    collation                  = string
    database_dialect           = optional(string, "GOOGLE_STANDARD_SQL")
    deletion_protection        = optional(bool, false)
    full_backup_enabled        = optional(bool, false)
    incremental_backup_enabled = optional(bool, false)
    backup_expire_time         = optional(string, "604800s")
    backup_schedule            = optional(string, "0 0 * * *")
    //   0 2/12 * * * : every 12 hours at (2, 14) hours past midnight in UTC.
    //   0 2,14 * * * : every 12 hours at (2,14) hours past midnight in UTC.
    //   0 2 * * *    : once a day at 2 past midnight in UTC.
    //   0 2 * * 0    : once a week every Sunday at 2 past midnight in UTC.
    //   0 2 8 * *    : once a month on 8th day at 2 past midnight in UTC.

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
