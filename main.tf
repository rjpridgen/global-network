terraform {
  required_version = ">= 1.11.4"
}

module "global-network" {
  source = "./modules/network"
  google_project_id = "siguiente-mexico"
  google_region = "northamerica-south1"
}
