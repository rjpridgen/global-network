terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 5.3.0"
    }
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 1.2"
}

provider "google" {
  project    = var.gcp_project_id
}
