terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }
  }
  required_version = ">= 1.11.4"
}

variable "token" {
  type = string
  ephemeral = true
}

provider "cloudflare" {
  api_token = var.token
}

variable "account" {
  type = string
}

module "aws-dns" {
  for_each = toset(["us-east-1", "us-east-2"])
  source = "./modules/amazon-firewall-region"
  region = each.value
  team = "ryanjeremypridgen"
  account = var.account
}

# module "global-network" {
#   source = "./modules/network"
#   google_project_id = "siguiente-mexico"
#   google_region = "northamerica-south1"
# }
