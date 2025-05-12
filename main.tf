terraform {
  required_version = ">= 1.11.4"
}

module "zero-trust-firewall" {
  source = "./modules/firewall"
  team = "ryanjeremypridgen"
  account = "02ee7b87eb8a52627a53b88821c9ae95"
}

module "global-network" {
  source = "./modules/network"
  google_project_id = "siguiente-mexico"
  google_region = "northamerica-south1"
}
