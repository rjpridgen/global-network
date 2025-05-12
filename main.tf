terraform {
  required_providers {
    google = {
      source = "hashicorp/google-beta"
      version = "6.34.0"
    }
  }
  required_version = ">= 1.11.4"
}

provider "google" {
  project = "siguiente-mexico"
  region = "northamerica-south1"
}

module "firewall" {
  source = "./modules/firewall"
}