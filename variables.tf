variable "random_instance_name" {
  type        = bool
  description = "Sets random suffix at the end of the instance resource name"
  default     = false
}
variable "name" {
  type        = string
  description = "The name of the instance"
}

variable "databases" {
  description = "A list of databases to be created"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}

variable "instance_iam" {
  type = list(object({
    role    = string
    members = list(string)
  }))
  default = []
}

variable "database_iam" {
  type = list(object({
    role          = string
    database_name = string
    members       = list(string)
  }))
  default = []
}

variable "processing_units" {
  description = "Processing Units"
  type        = number
  default     = 1000
}
