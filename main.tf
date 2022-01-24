locals {
  master_instance_name = var.random_instance_name ? "${var.name}-${random_id.suffix[0].hex}" : var.name
  instance_iam         = { for iam in var.instance_iam : iam.role => iam }
  databases            = { for db in var.databases : db.name => db }
}

resource "random_id" "suffix" {
  count       = var.random_instance_name ? 1 : 0
  byte_length = 4
}

resource "google_spanner_instance" "default" {
  config           = "regional-us-west3"
  display_name     = local.master_instance_name
  processing_units = var.processing_units
}

resource "google_spanner_database" "default" {
  for_each            = local.databases
  instance            = google_spanner_instance.default.name
  name                = each.value.name
  deletion_protection = false
}

# Instance IAM
resource "google_spanner_instance_iam_binding" "instance" {
  for_each = local.instance_iam
  instance = google_spanner_instance.default.name
  role     = each.value.role
  members  = each.value.members
}

# Database IAM
module "db-iam" {
  source   = "./spanner-db-iam"
  instance = google_spanner_instance.default.name
  iams     = var.iams
}
