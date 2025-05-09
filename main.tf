terraform {
  required_version = ">= 1.11.4"
}

module "firewall" {
  source = "./modules/firewall"
}