locals {
  master_instance_name = var.random_instance_name ? "${var.name}-${random_id.suffix[0].hex}" : var.name
  instance_iam         = { for iam in var.instance_iam : iam.role => iam }
  databases            = { for db in var.databases : db.name => db }
  database_ids = [ for item in var.databases: item.name ]
}

resource "random_id" "suffix" {
  count       = var.random_instance_name ? 1 : 0
  byte_length = 4
}

resource "google_spanner_instance" "default" {
  config           = var.config
  display_name     = local.master_instance_name
  processing_units = var.processing_units
}

resource "google_spanner_database" "default" {
  for_each            = local.databases
  instance            = google_spanner_instance.default.name
  name                = each.value.name
  deletion_protection = each.value.deletion_protection
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
  iams     = var.database_iam
}

# Databases Backup
module "automated-db-backup" {
  count = var.enable_automated_backup ? 1 : 0
  source  = "github.com/dapperlabs-platform/terraform-gcp-spanner-backup?ref=v0.1.1"
  database_ids = local.database_ids
  spanner_instance_id = google_spanner_instance.default.name
  gcp_project_id = var.gcp_project_id
  location = var.location
  pubsub_topic = var.pubsub_topic
  region = var.region
}
