terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

locals {
  condition = [
    for id in var.domain_block_lists : "any(dns.domains[*] in ${"$"}${id})"
  ]
}

resource "cloudflare_zero_trust_gateway_policy" "domain_block" {
  account_id  = var.account
  action      = "block"
  name        = "Domain Block"
  description = "Block bad websites based on their host name."
  enabled     = true
  filters     = ["dns"]
  precedence  = 10
  traffic = join(" or ", local.condition)
}

resource "cloudflare_zero_trust_gateway_policy" "allow" {
  account_id  = var.account
  action      = "allow"
  name        = "IP Allow"
  description = "Allow IP list access."
  enabled     = true
  filters     = ["dns"]
  precedence  = 20
  traffic = join(" or ", [
    for id in var.ip_allow_lists : "any(net.dst.ip[*] in ${"$"}${id})"
  ])
}
