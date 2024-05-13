terraform {
  required_version = ">=1.1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }
}

provider "google" {
  region = local.location
}
