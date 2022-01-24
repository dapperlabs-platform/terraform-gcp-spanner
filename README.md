# terraform-gcp-spanner
Terraform Code for provisioning GCP spanner resources

### Example Usage
```
module "cloud-spanner-instance" {
  source = "github.com/dapperlabs-platform/terraform-gcp-spanner?ref=v0.0.3"
  
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