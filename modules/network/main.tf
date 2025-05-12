terraform {
  required_version = ">= 1.11.4"
}

provider "google" {
  project = var.google_project_id
  region = var.google_region
}

resource "google_compute_network" "this" {
  name                    = "vpc-siguiente-global"
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
  mtu                     = 1460
}