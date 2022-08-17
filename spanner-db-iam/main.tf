#resource "google_spanner_database_iam_binding" "default" {
#  for_each = var.iams
#  database = each.value.database_name
#  instance = var.instance
#  members  = each.value.members
#  role     = each.value.role
#}
locals {
  database_role_member = flatten([
    for k, iamEntry in var.iams :
    [
      for membr in iamEntry.members : {
        role     = iamEntry.role
        member   = membr
        database = iamEntry.database_name
      }
    ]
  ])
}
resource "google_spanner_database_iam_member" "database" {
  count    = length(local.database_role_member)
  instance = var.instance
  database = local.database_role_member[count.index].database
  role     = local.database_role_member[count.index].role
  member   = local.database_role_member[count.index].member
}
