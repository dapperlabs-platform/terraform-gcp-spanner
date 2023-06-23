locals {
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

resource "google_spanner_instance" "default" {
  config           = var.config
  display_name     = var.name
  name             = var.name
  processing_units = var.processing_units
  labels           = var.labels
}

resource "google_spanner_database" "default" {
  for_each            = local.databases
  instance            = google_spanner_instance.default.name
  name                = each.value.name
  database_dialect    = each.value.database_dialect
  deletion_protection = each.value.deletion_protection
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
  count          = (var.backup_enabled == true ? 1 : 0)
  source         = "github.com/dapperlabs-platform/terraform-gcp-spanner-backup?ref=v0.2.1"
  database_names = local.database_ids
  instance_name  = google_spanner_instance.default.name
  project_name   = data.google_client_config.this.project
}
