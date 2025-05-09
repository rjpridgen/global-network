terraform {
  required_version = ">= 1.2"
}

module "firewall" {
  source = "./modules/firewall"
}