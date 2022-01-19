variable "databases" {
  default = ""
}
locals {
  master_instance_name = var.random_instance_name ?  "${var.name}-${random_id.suffix[0].hex}" : var.name

  databases = { for db in var.databases : db.name => db }
  users = {  }
}