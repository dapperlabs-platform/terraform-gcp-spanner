locals {
  master_instance_name = var.random_instance_name ? "${var.name}-${random_id.suffix[0].hex}" : var.name

  databases = { for db in var.databases : db.name => db }
  users     = { for u in var.additional_users : u.name => u }
}

resource "random_id" "suffix" {
  count = var.random_instance_name ? 1 : 0

  byte_length = 4
}

resource "google_spanner_instance" "default" {
  config       = "regional-us-west3"
  display_name = local.master_instance_name
  num_nodes    = var.num_nodes
}

resource "google_spanner_database" "default" {
  for_each = local.databases
  instance = google_spanner_instance.default
  name     = each.value.name
  deletion_protection = false
}
