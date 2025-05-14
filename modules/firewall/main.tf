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

provider "cloudflare" {
  api_token = var.token
}

data "http" "github_meta" {
  url = "https://api.github.com/meta"
}

data "http" "amazon_web_services" {
  for_each = toset([
    "https://configuration.private-access.console.amazonaws.com/us-east-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/us-east-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/us-west-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ca-central-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-central-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-west-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-west-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/il-central-1.config.json"
  ])
  url = each.value
}

locals {
  services = flatten([ for response in data.http.amazon_web_services : jsondecode(response.body).ServiceDetails ])
  ipv4 = flatten([ for service in local.services : service.PrivateIpv4DnsNames if can(service.PrivateIpv4DnsNames) ])
}

resource "cloudflare_zero_trust_list" "amazon_ipv4" {
  name = "Amazon IPv4"
  description = "AWS ipv4 DNS"
  account_id = var.account
  type = "DOMAIN"
  items = [
    for s in local.ipv4 : {
      value = s
    }
  ]
}

resource "cloudflare_zero_trust_gateway_policy" "aws_block" {
  account_id = var.account
  action = "block"
  name = "Block AWS"
  description = "Block direct AWS egress traffic."
  device_posture = ""
  enabled = true
  filters = ["dns"]
  precedence = 0
  rule_settings = {
    block_page_enabled = true
    block_reason = "This website is a security risk"
  }
  traffic = "any(dns.domains[*] in {\"${cloudflare_zero_trust_list.amazon_ipv4.id}\"})"
}