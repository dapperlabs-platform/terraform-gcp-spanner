variable "max_size" {
  type        = number
  default     = 2000
  description = "Maximum size that the spanner instance can be scaled out to."
}

variable "min_size" {
  type        = number
  default     = 100
  description = "Minimum size that the spanner instance can be scaled in to."
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-west1"
}

variable "scale_in_cooling_minutes" {
  type        = number
  default     = 30
  description = "Minutes to wait after scaling IN or OUT before a scale IN event can be processed."
}

variable "scale_out_cooling_minutes" {
  type        = number
  default     = 2
  description = "Minutes to wait after scaling IN or OUT before a scale OUT event can be processed."
}

variable "scaling_method" {
  type        = string
  default     = "LINEAR"
  description = "Algorithm that should be used to manage the scaling of the spanner instance: STEPWISE, LINEAR, DIRECT"
}

variable "schedule" {
  type    = string
  default = "*/2 * * * *"
}

variable "spanner_name" {
  type    = string
  default = "autoscale-test"
}

variable "spanner_state_name" {
  type    = string
  default = "autoscale-test-state"
}

variable "spanner_state_processing_units" {
  description = "Default processing units for state Spanner, if created"
  default     = 100
}

variable "terraform_spanner_state" {
  description = "If set to true, Terraform will create a Cloud Spanner instance and DB to hold the Autoscaler state."
  type        = bool
  default     = false
}
