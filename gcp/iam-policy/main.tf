resource "google_project_iam_member" "owners" {
  count   = length(var.owners)
  member  = var.owners[count.index]
  role    = "roles/owner"
}

resource "google_project_iam_member" "editors" {
  count   = length(var.editors)
  member  = var.editors[count.index]
  role    = "roles/editor"
}

resource "google_project_iam_member" "viewers" {
  count   = length(var.viewers)
  member  = var.viewers[count.index]
  role    = "roles/viewer"
}

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