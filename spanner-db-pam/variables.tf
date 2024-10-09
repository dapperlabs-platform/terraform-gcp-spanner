variable "pam_access" {
  type = map(object({
    name         = string
    role         = string
    max_time     = string
    auto_approve = bool
    requesters   = list(string)
    approvers    = optional(list(string)) #Required if auto_approve is true
  }))
}

variable "project_name" {
  type = string
}
