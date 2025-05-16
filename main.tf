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
  backend "local" {
    path = ".tfstate/terraform.tfstate"
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

module "security" {
  source = "./modules/zero-trust"
  id = "siguiente-seguridad-testnet1"
  account_id = var.account
}

module "github_dns" {
  for_each = toset([
    "hooks",
    "web",
    "api",
    "git",
    "packages",
    "pages",
    "importer",
    "codespaces",
    "dependabot",
    "copilot"
  ])
  source = "./modules/github-firewall"
  account_id = var.account
  category = each.value
}

module "aws_dns" {
  for_each = toset([
    "us-east-1",
    "us-east-2",
    "us-west-2",
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-southeast-1",
    "ap-southeast-2",
    "ap-south-1",
    "ap-south-2",
    "ca-central-1",
    "eu-central-1",
    "eu-west-1",
    "eu-west-2",
    "il-central-1"
  ])
  source  = "./modules/amazon-firewall-region"
  region  = each.value
  account = var.account
}

module "gateway" {
  source  = "./modules/dns-gateway"
  account = var.account
  domain_block_lists = [
    for arr in module.aws_dns : arr.list_id
  ]
}


# module "global-network" {
#   source = "./modules/network"
#   google_project_id = "siguiente-mexico"
#   google_region = "northamerica-south1"
# }
