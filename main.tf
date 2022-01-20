locals {
  master_instance_name = var.random_instance_name ? "${var.name}-${random_id.suffix[0].hex}" : var.name

  databases = { for db in var.databases : db.name => db }
}

resource "random_id" "suffix" {
  count = var.random_instance_name ? 1 : 0

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
resource "google_spanner_instance_iam_member" "instance" {
  for_each = var.instance_iam
  instance = google_spanner_instance.default.name
  role     = each.key
  member   = each.value
}

# Database IAM
#resource "google_spanner_database_iam_member" "database" {
#  for_each = var.database_iam
#  instance = google_spanner_instance.default.name
#  database = google_spanner_database.default.name
#  role     = each.key
#  member   = each.value
#}
