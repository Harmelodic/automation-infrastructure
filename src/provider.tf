terraform {
  required_version = ">=1.1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.0"
    }
  }
}

provider "google" {
  region = local.location
}
