
resource "google_privileged_access_manager_entitlement" "entitlement" {
  for_each = var.pam_access

  entitlement_id       = var.pam_access[each.key].name
  location             = "global"
  max_request_duration = var.pam_access[each.key].max_time
  parent               = "projects/${var.project_name}"
  requester_justification_config {
    unstructured {}
  }
  eligible_users {
    principals = [
      var.pam_access[each.key].requesters
    ]
  }
  privileged_access {
    gcp_iam_access {
      role_bindings {
        role = var.pam_access[each.key].role
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
  #     local.pam_access[each.key].requesters
  #   ]
  # }
  approval_workflow {
    manual_approvals {
      require_approver_justification = true
      steps {
        approvals_needed = 1
        approver_email_recipients = [
          var.pam_access[each.key].approvers
        ]
        approvers {
          principals = [
            var.pam_access[each.key].approvers
          ]
        }
      }
    }
  }
}

