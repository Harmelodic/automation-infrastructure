resource "google_project_iam_custom_role" "custom-role" {
  description = var.description
  permissions = var.permissions
  role_id     = var.role_id
  title       = var.title
}

output "role" {
  value = google_project_iam_custom_role.custom-role.role_id
}

variable "permissions" {}
variable "role_id" {}
variable "title" {}

variable "description" {
  default = ""
}