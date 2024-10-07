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
  alias_name   = var.alias_name != "" ? var.alias_name : var.name
  databases    = { for db in var.databases : db.name => db }
  database_ids = [for item in var.databases : item.name]
  display_name = var.display_name != "" ? var.display_name : var.name
}

resource "google_spanner_instance" "default" {
  config           = var.config
  display_name     = local.display_name
  name             = var.name
  processing_units = var.autoscale_enabled == true ? var.autoscale_min_size : var.processing_units
  labels           = var.labels

  lifecycle {
    ignore_changes = [processing_units]
  }
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

# Database Autoscaler
module "db-autoscaler" {
  count                          = (var.autoscale_enabled == true ? 1 : 0)
  source                         = "./spanner-autoscaler"
  max_size                       = var.autoscale_max_size
  min_size                       = var.autoscale_min_size
  project_id                     = var.project_id
  scale_in_cooling_minutes       = var.autoscale_in_cooling_minutes
  scale_out_cooling_minutes      = var.autoscale_out_cooling_minutes
  scaling_method                 = var.autoscale_method
  schedule                       = var.autoscale_schedule
  spanner_alias_name             = local.alias_name
  spanner_name                   = google_spanner_instance.default.name
  spanner_state_name             = "${local.alias_name}-state"
  spanner_state_processing_units = 100
  terraform_spanner_state        = true
  depends_on                     = [google_spanner_database.default]
}

# Databases Backup
module "automated-db-backup" {
  count                  = (var.backup_enabled == true ? 1 : 0)
  source                 = "github.com/dapperlabs-platform/terraform-gcp-spanner-backup?ref=v0.2.4"
  database_names         = local.database_ids
  instance_name          = google_spanner_instance.default.name
  instance_alias_name    = local.alias_name
  project_name           = var.project_id
  backup_deadline        = var.backup_deadline
  backup_expire_time     = var.backup_expire_time
  backup_schedule        = var.backup_schedule
  backup_schedule_region = var.backup_schedule_region
  backup_time_zone       = var.backup_time_zone
}
