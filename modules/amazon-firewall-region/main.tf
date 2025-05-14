terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    http = {
      source = "hashicorp/http"
    }
  }
}

data "http" "this" {
  url = "https://configuration.private-access.console.amazonaws.com/${var.region}.config.json"
}

locals {
  config = jsondecode(data.http.this.body)
  ipv4   = [for service in local.config.ServiceDetails : service.PrivateIpv4DnsNames if can(service.PrivateIpv4DnsNames)]
  ipv4_domains = [for hostname in flatten(local.ipv4) : hostname if !strcontains(hostname, "*")]
}

resource "cloudflare_zero_trust_list" "amazon_ipv4" {
  name        = "Amazon IPv4 (${var.region})"
  description = "AWS ipv4 DNS for ${var.region}"
  account_id  = var.account
  type        = "DOMAIN"
  items = [
    for s in local.ipv4_domains : {
      value = s
    }
  ]
}
