terraform {
  required_version = ">=1.0.3"

  backend "gcs" {
    bucket = "harmelodic-terraform-state"
    prefix = "ops"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.79.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "GCP Project ID"
  sensitive   = true
  type        = string
}

variable "region" {
  default     = "europe-north1"
  description = "GCP Region"
  sensitive   = true
  type        = string
}
