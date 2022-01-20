# terraform-gcp-spanner
Terraform Code for provisioning GCP spanner resources

### Example Usage
```
module "cloud-spanner-instance" {
  #  source = "github.com/dapperlabs-platform/terraform-gcp-spanner?ref=v0.0.3"
  source = "./cloud-spanner-instance"

  instance_iam = {
    # Admin
    "roles/spanner.admin"        = ["group:admin@dapperlabs.com"]
    "roles/spanner.backupAdmin"  = ["group:admin@dapperlabs.com"]
    "roles/spanner.restoreAdmin" = ["group:admin@dapperlabs.com"]

    # Writer
    "roles/spanner.backupWriter" = ["group:writers@dapperlabs.com"]

    # Viewer
    "roles/spanner.viewer" = ["group:readers@dapperlabs.com"]
  }

    database_iam = {
      # Admin
      "roles/spanner.databaseAdmin" = ["group:admin@dapperlabs.com"]

      # Writer
      "roles/spanner.databaseUser" = ["group:writers@dapperlabs.com"]

      # Reader
      "roles/spanner.databaseReader" = ["group:readers@dapperlabs.com"]
    }

  name = "demo-instance"
  databases = [{
    name      = "consumer-db"
    charset   = "UTF8"
    collation = "en_US.UTF8"
    }, {
    name      = "waterhose-db"
    charset   = "UTF8"
    collation = "en_US.UTF8"
    },
  ]
}
```