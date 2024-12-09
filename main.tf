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
  edition          = var.edition
  processing_units = var.autoscale_enabled == true ? null : var.processing_units

  dynamic "autoscaling_config" {
    for_each = var.autoscale_enabled == true ? [1] : []
    content {
      autoscaling_limits {
        max_processing_units = var.autoscale_max_size
        min_processing_units = var.autoscale_min_size
      }
      autoscaling_targets {
        high_priority_cpu_utilization_percent = var.autoscale_cpu_utilization
        storage_utilization_percent           = var.autoscale_storage_utilization
      }
    }
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

# Database PAM
module "db-pam" {
  source       = "./spanner-db-pam"
  for_each     = var.pam_access
  project_name = var.project_id
  pam_access = {
    role = {
      name         = var.pam_access[each.key].name
      role         = var.pam_access[each.key].role
      max_time     = var.pam_access[each.key].max_time
      auto_approve = var.pam_access[each.key].auto_approve
      requesters   = var.pam_access[each.key].requesters
      approvers    = var.pam_access[each.key].approvers
    }
  }
}

resource "google_spanner_backup_schedule" "full-backup" {
  count    = (var.backup_enabled == true ? 1 : 0)
  instance = google_spanner_instance.default.name
  database = google_spanner_database.default.name
  name     = var.name

  retention_duration = vvar.backup_expire_time // 366 days (maximum possible retention)

  spec {
    cron_spec {
      //   0 2/12 * * * : every 12 hours at (2, 14) hours past midnight in UTC.
      //   0 2,14 * * * : every 12 hours at (2,14) hours past midnight in UTC.
      //   0 2 * * *    : once a day at 2 past midnight in UTC.
      //   0 2 * * 0    : once a week every Sunday at 2 past midnight in UTC.
      //   0 2 8 * *    : once a month on 8th day at 2 past midnight in UTC.
      text = var.backup_schedule
    }
  }
  // The schedule creates only full backups.
  full_backup_spec {}
}
