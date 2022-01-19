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
variable "additional_users" {
  description = "A list of users to be created in your cluster"
  type = list(object({
    name     = string
    password = string
  }))
  default = []
}

variable "num_nodes" {
  description = "Number of nodes"
  type        = number
  default     = 1
}
