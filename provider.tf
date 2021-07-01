terraform {
  required_version = ">=1.0.0"

  backend "gcs" {
    bucket = "harm-personal-projects-terraform-state"
    prefix = "ops"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.74.0"
    }
  }
}

provider "google" {
  region = "europe-north1"
}
