# terraform-gcp-spanner
Terraform Code for provisioning GCP spanner resources

### Example Usage
```
module "cloud-spanner-instance" {
  source = "github.com/work-platform/terraform-gcp-spanner?ref=v0.6.0"
  
  instance_iam = [
    # Admin
    { role    = "roles/spanner.admin", members = ["group:admin@work.com"] },
    { role    = "roles/spanner.backupAdmin", members = ["group:admin@work.com"]},
    { role    = "roles/spanner.restoreAdmin", members = ["group:admin@work.com"]},

    # Writer
    { role    = "roles/spanner.backupWriter", members = ["group:writers@work.com"]},

    # Readers
    { role    = "roles/spanner.viewer", members = ["group:readers@work.com"]}
   ]

  autoscale_enabled             = true
  autoscale_max_size            = 8000
  autoscale_min_size            = 1000 
  autoscale_out_cooling_minutes = 1
  autoscale_schedule            = "* * * * *"                      # every minute
  backup_expire_time            = 259200                           # 3 days
  config                        = "regional-${var.default_region}" 
  name                          = "gcp-env"
  project_id                    = var.project_name

  databases = [{
    name             = "db1"
    charset          = "UTF8"
    collation        = "en_US.UTF8"
    database_dialect = "GOOGLE_STANDARD_SQL"
    }
  ]
  
  database_iam = {
    "admins_db2" = {
      role          = "roles/spanner.databaseAdmin",
      database_name = "db2",
      members       = ["group:admin@work.com"]
    },
    "readers_db2" = {
      role          = "roles/spanner.viewer",
      database_name = "db2",
      members       = ["group:readers@work.com"]
    },
    "admins_db1" = {
      role          = "roles/spanner.databaseAdmin",
      database_name = "db1",
      members       = ["group:admin@work.com"]
    },
    "readers_db1" = {
      role          = "roles/spanner.viewer",
      database_name = "db1",
      members       = ["group:readers@work.com"]
    }
  }

    pam_access = {
    "spanner-db-user" = {
      name         = "spanner-db-user-terraformed"
      role         = "User"
      max_time     = "86400s" # 1 day
      auto_approve = false    # If true approvers are not required
      requesters = [
        "group:dev-group@work.com",
      ]
      approvers = [
        "user:manager@work.com",
        "group:manager-group@work.com",
      ]
    },
    # Auto grant
    "spanner-db-user-auto-grant" = {
      name         = "spanner-db-user-auto-grant-terraformed"
      role         = "User"
      max_time     = "86400s" # 1 day
      auto_approve = true     # If true approvers are not required
      requesters = [
        "group:manager-group@work.com",
        "user:manager@work.com",
      ]
    },
  }
}
```
