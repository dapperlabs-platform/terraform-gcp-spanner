# terraform-gcp-spanner
Terraform Code for provisioning GCP spanner resources

### Example Usage
```
module "cloud-spanner-instance" {
  source = "github.com/dapperlabs-platform/terraform-gcp-spanner?ref=v0.2.0"
  
  instance_iam = [
    # Admin
    { role    = "roles/spanner.admin", members = ["group:admin@dapperlabs.com"] },
    { role    = "roles/spanner.backupAdmin", members = ["group:admin@dapperlabs.com"]},
    { role    = "roles/spanner.restoreAdmin", members = ["group:admin@dapperlabs.com"]},

    # Writer
    { role    = "roles/spanner.backupWriter", members = ["group:writers@dapperlabs.com"]},

    # Readers
    { role    = "roles/spanner.viewer", members = ["group:readers@dapperlabs.com"]}
   ]

   display_name = "demo-instance"
   name         = "demo-instance"
   config.      = "regional-us-central1" # see https://cloud.google.com/spanner/docs/instance-configurations
   
   databases = [{
    name      = "db1"
    charset   = "UTF8"
    collation = "en_US.UTF8"
    }, {
    name      = "db1"
    charset   = "UTF8"
    collation = "en_US.UTF8"
    },
  ]
  
  database_iam = {
    "admins_db2" = {
      role          = "roles/spanner.databaseAdmin",
      database_name = "db2",
      members       = ["group:admin@dapperlabs.com"]
    },
    "readers_db2" = {
      role          = "roles/spanner.viewer",
      database_name = "db2",
      members       = ["group:readers@dapperlabs.com"]
    },
    "admins_db1" = {
      role          = "roles/spanner.databaseAdmin",
      database_name = "db1",
      members       = ["group:admin@dapperlabs.com"]
    },
    "readers_db1" = {
      role          = "roles/spanner.viewer",
      database_name = "db1",
      members       = ["group:readers@dapperlabs.com"]
    }
  }
}
```
