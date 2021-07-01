terraform {
  backend "gcs" {
    bucket = "harm-personal-projects-terraform-state"
    prefix = "ops"
  }
}