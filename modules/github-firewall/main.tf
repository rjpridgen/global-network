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
    url = "https://api.github.com/meta"
}

locals {
    address_list = jsondecode(data.http.this.response_body)
    cidr = [
        for address in local.address_list[var.category] : {
            value = address
        }
    ]
}

resource "cloudflare_zero_trust_list" "this" {
    account_id = var.account_id
    name = "Github (${var.category})"
    type = "IP"
    items = local.cidr
}
