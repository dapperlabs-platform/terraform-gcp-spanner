
resource "google_privileged_access_manager_entitlement" "entitlement" {
  for_each = var.pam_access

  entitlement_id       = each.value.name
  location             = "global"
  max_request_duration = each.value.max_time
  parent               = "projects/${var.project_name}"
  requester_justification_config {
    unstructured {}
  }
  eligible_users {
    principals = each.value.requesters
  }
  privileged_access {
    gcp_iam_access {
      role_bindings {
        role = "roles/spanner.database${each.value.role}"
        #condition_expression = "request.time < timestamp(\"2024-04-23T18:30:00.000Z\")"
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${var.project_name}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"
    }
  }
  # additional_notification_targets {
  #   admin_email_recipients = [
  #     "user@example.com",
  #   ]
  #   requester_email_recipients = [
  #     each.value.requesters
  #   ]
  # }

  dynamic "approval_workflow" {
    for_each = each.value.auto == true ? [] : [1]
    content {
      manual_approvals {
        require_approver_justification = true
        steps {
          approvals_needed          = 1
          approver_email_recipients = each.value.approvers
          approvers {
            principals = each.value.approvers
          }
        }
      }
    }
  }
}
