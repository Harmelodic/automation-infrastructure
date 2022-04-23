resource "random_integer" "automation_project_suffix" {
  min = 1
  max = 999999
}

resource "google_project" "automation" {
  name                = "automation"
  project_id          = "automation-${random_integer.automation_project_suffix.result}"
  folder_id           = google_folder.automation.id
  billing_account     = data.google_billing_account.my_billing_account.id
  auto_create_network = false
}

resource "google_project_service" "automation_apis" {
  for_each = toset([
    "cloudbilling.googleapis.com", # Required for hooking up Cloud Billing to the automation project
    "cloudkms.googleapis.com", # Required for using CMEK on Terraform state bucket
    "cloudresourcemanager.googleapis.com", # Required for managing GCP folders
    "iam.googleapis.com", # Required for managing IAM
    "iamcredentials.googleapis.com", # Required for handling Service Account tokens (Workload Identity)
    "serviceusage.googleapis.com", # Required as a pre-requisite for creating further projects
    "storage.googleapis.com", # Required for storing Terraform state
    "sts.googleapis.com", # Required for handling short-lived Security Tokens

    # APIs that need enabling for provisioning infra in other projects:
    "container.googleapis.com", # Required for provisioning GKE clusters
  ])

  project                    = google_project.automation.id
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = true
}
