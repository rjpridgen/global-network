terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 5.4.0"
    }
  }
}

variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
  default = "02ee7b87eb8a52627a53b88821c9ae95"
}

resource "cloudflare_zero_trust_gateway_policy" "isolate" {
  account_id = var.account_id
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