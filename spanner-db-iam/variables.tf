variable "iams" {
  type = map(object({
    role          = string
    database_name = string
    members       = list(string)
  }))
}

variable "instance" {
  type = string
}
