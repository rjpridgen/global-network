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

resource "google_compute_network" "vpc_siguiente_global" {
  name                    = "vpc-siguiente-global"
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
  mtu                     = 1460
}

module "firewall" {
  source = "./modules/firewall"
}