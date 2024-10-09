variable "pam_access" {
  type = map(object({
    name         = string
    role         = string
    max_time     = string
    auto_approve = bool
    requesters   = list(string)
    approvers    = list(string)
  }))
}

variable "project_name" {
  type = string
}
