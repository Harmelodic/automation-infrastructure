terraform {
  required_version = ">=1.1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "google" {
  region = local.location
}
