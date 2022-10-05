terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  master_instance_name = var.random_instance_name ? "${var.name}-${random_id.suffix[0].hex}" : var.name
  #  instance_iam         = { for iam in var.instance_iam : iam.role => iam }
  instance_role_member = flatten([
    for iamEntry in var.instance_iam :
    [
      for membr in iamEntry.members :
      {
        role   = iamEntry.role
        member = membr
      }
    ]
  ])
  databases    = { for db in var.databases : db.name => db }
  database_ids = [for item in var.databases : item.name]
}

data "google_client_config" "this" {}

resource "random_id" "suffix" {
  count       = var.random_instance_name ? 1 : 0
  byte_length = 4
}

resource "google_spanner_instance" "default" {
  config           = var.config
  display_name     = local.master_instance_name
  name             = local.master_instance_name
  processing_units = var.processing_units
}

resource "google_spanner_database" "default" {
  for_each            = local.databases
  instance            = google_spanner_instance.default.name
  name                = each.value.name
  database_dialect    = coalesce(each.value.database_dialect, "GOOGLE_STANDARD_SQL")
  deletion_protection = coalesce(each.value.deletion_protection, true) ? true : false
}

resource "google_spanner_instance_iam_member" "instance" {
  count    = length(local.instance_role_member)
  instance = google_spanner_instance.default.name
  role     = local.instance_role_member[count.index].role
  member   = local.instance_role_member[count.index].member
}

# Database IAM
module "db-iam" {
  source     = "./spanner-db-iam"
  instance   = google_spanner_instance.default.name
  iams       = var.database_iam
  depends_on = [google_spanner_database.default]
}

# Databases Backup
module "automated-db-backup" {
  count               = var.backup_enabled ? 1 : 0
  source              = "github.com/dapperlabs-platform/terraform-gcp-spanner-backup?ref=v0.1.6"
  database_ids        = local.database_ids
  spanner_instance_id = google_spanner_instance.default.name
  gcp_project_id      = data.google_client_config.this.project
  location            = var.backup_location
  pubsub_topic        = var.backup_pubsub_topic
  region              = var.backup_region
}
