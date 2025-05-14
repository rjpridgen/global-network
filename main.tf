terraform {
  required_version = ">= 1.11.4"
}

variable "account" {
  type = string
}

variable "token" {
  type = string
  ephemeral = true
}

module "zero-trust-firewall" {
  source = "./modules/firewall"
  team = "ryanjeremypridgen"
  account = var.account
  token = var.token
}

# module "global-network" {
#   source = "./modules/network"
#   google_project_id = "siguiente-mexico"
#   google_region = "northamerica-south1"
# }
