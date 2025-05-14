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
}

data "http" "github_meta" {
  url = "https://api.github.com/meta"
}

data "http" "amazon_web_services" {
  for_each = toset([
    "https://configuration.private-access.console.amazonaws.com/us-east-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/us-east-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/us-west-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-northeast-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-northeast-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-southeast-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-southeast-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-south-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-south-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ca-central-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-central-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-west-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-west-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/il-central-1.config.json"
  ])
  url = each.value
}

locals {
  services = [ for response in data.http.amazon_web_services : jsondecode(response.body).ServiceDetails ]
  ipv4 = flatten([ for service in local.services : service.PrivateIpv4DnsNames if can(service.PrivateIpv4DnsNames) ])
}

data "cloudflare_account" "example_account" {
  filter {
    name = "Siguiente"
  }
}

resource "cloudflare_zero_trust_list" "amazon_ipv4" {
  name = "Amazon IPv4"
  description = "AWS ipv4 DNS"
  account_id = data.cloudflare_accounts.this.account_id
  type = "DOMAIN"
  items = [
    for s in local.ipv4 : {
      value = tostring(s)
    }
  ]
}
