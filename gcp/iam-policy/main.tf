resource "google_project_iam_member" "owners" {
  count   = length(var.owners)
  member  = var.owners[count.index]
  project = var.project
  role    = "roles/owners"
}

resource "google_project_iam_member" "editors" {
  count   = length(var.editors)
  member  = var.editors[count.index]
  project = var.project
  role    = "roles/editors"
}

resource "google_project_iam_member" "viewers" {
  count   = length(var.viewers)
  member  = var.viewers[count.index]
  project = var.project
  role    = "roles/viewers"
}

variable "project" {}

variable "editors" {
  type    = list(string)
  default = []
}

variable "owners" {
  type    = list(string)
  default = []
}

variable "viewers" {
  type    = list(string)
  default = []
}