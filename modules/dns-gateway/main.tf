terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

locals {
  block_lists = join(", ", var.domain_block_lists)
}

resource "cloudflare_zero_trust_gateway_policy" "domain_block" {
  account_id  = var.account
  action      = "block"
  name        = "Domain Block"
  description = "Block bad websites based on their host name."
  enabled     = true
  filters     = ["dns"]
  precedence  = 0
  traffic = join(" or ", [
    for id in local.block_lists : "any(dns.domains[*] in {${id}})"
  ])
}
