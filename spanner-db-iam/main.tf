resource "google_spanner_database_iam_member" "default" {
  for_each = var.iams
  database = each.value.database_name
  instance = var.instance
  member  = each.value.members
  role     = each.value.role
}
