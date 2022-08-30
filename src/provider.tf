terraform {
  required_version = ">=1.1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.34.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.0"
    }
  }
}

provider "google" {
  region = local.location
}
