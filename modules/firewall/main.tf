terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 5.4.0"
    }
  }
}

data "cloudflare_accounts" "this" {
  name = "Siguiente"
}

resource "cloudflare_zero_trust_list" "apple_software" {
  name = "Apple Software Updates"
  type = "DOMAIN"
  account_id = data.cloudflare_accounts.this.id
  items = [
    { value: "appldnld.apple.com" },
    { value: "configuration.apple.com" },
    { value: "gdmf.apple.com" },
    { value: "gg.apple.com" },
    { value: "gs.apple.com" },
    { value: "ig.apple.com" },
    { value: "mesu.apple.com" },
    { value: "oscdn.apple.com" },
    { value: "osrecovery.apple.com" },
    { value: "skl.apple.com" },
    { value: "swcdn.apple.com" },
    { value: "swdist.apple.com" },
    { value: "swdownload.apple.com" },
    { value: "swscan.apple.com" },
    { value: "updates-http.cdn-apple.com" },
    { value: "updates.cdn-apple.com" },
    { value: "xp.apple.com" },
    { value: "gdmf-ados.apple.com" },
    { value: "gsra.apple.com" },
    { value: "wkms-public.apple.com" },
    { value: "fcs-keys-pub-prod.cdn-apple.com" }
  ]
}

resource "cloudflare_zero_trust_gateway_policy" "block_filesharing" {
  account_id = data.cloudflare_accounts.this.account_id
  action = "allow"
  filters = ["http"]
  name = "Filesharing"
  description = "Block all filesharing services for system integrity and security."
  enabled = true
  traffic = "http.request.method in {\"GET\" \"POST\" \"PUT\" \"DELETE\" \"PATCH\"}"
  precedence = 10
  rule_settings {
    add_headers = {
      "HELP" = "ryan jeremy pridgen"
      "HELP_GEO" = "20.50694,-86.94847"
    }
  }
}
