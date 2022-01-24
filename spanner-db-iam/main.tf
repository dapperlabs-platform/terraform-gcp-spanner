resource "google_spanner_database_iam_binding" "default" {
  for_each = var.iams
  database = each.value.database_name
  instance = var.instance
  members  = each.value.members
  role     = each.value.role
}