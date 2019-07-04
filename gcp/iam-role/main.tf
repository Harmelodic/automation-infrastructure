resource "google_project_iam_custom_role" "custom-role" {
  description = var.description
  permissions = var.permissions
  project     = var.project
  role_id     = var.role_id
  title       = var.title
}

variable "permissions" {}
variable "project" {}
variable "role_id" {}
variable "title" {}

variable "description" {
  default = ""
}