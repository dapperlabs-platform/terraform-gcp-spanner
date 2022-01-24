variable "iams" {
  type = map(object({
    role          = string
    database_name = string
    members       = list(string)
  }))
  default = {}
}

variable "instance" {
  type = string
}
