terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 5.3.0"
    }
  }
}

data "cloudflare_accounts" "this" {
  name = "Siguiente"
}

resource "cloudflare_zero_trust_gateway_policy" "example_zero_trust_gateway_policy" {
  account_id = data.cloudflare_accounts.this.id
  action = "isolate"
  filters = ["http"]
  name = "Isolation"
  description = "Browser isolation policy for all HTTP browser traffic."
  enabled = true
  precedence = 10000
  traffic = "http.request.method in {\"GET\" \"POST\" \"PUT\" \"DELETE\" \"PATCH\"}"
  rule_settings = {
    biso_admin_controls = {
      copy = "remote_only"
      dcp = false
      dd = false
      dk = false
      download = "enabled"
      dp = false
      du = false
      keyboard = "enabled"
      paste = "enabled"
      printing = "enabled"
      upload = "enabled"
      version = "v1"
    }
  }
}