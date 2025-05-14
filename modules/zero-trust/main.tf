terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

locals {
  auth_domain = "${var.id}.cloudflareaccess.com"
}

# resource "cloudflare_zero_trust_organization" "example_zero_trust_organization" {
#   account_id = var.account_id
#   allow_authenticate_via_warp = false
#   auth_domain = local.auth_domain
#   auto_redirect_to_identity = true
#   is_ui_read_only = true
#   login_design = {
#     background_color = "#c5ed1b"
#     footer_text = "This is an example description."
#     header_text = "This is an example description."
#     logo_path = "https://example.com/logo.png"
#     text_color = "#c5ed1b"
#   }
#   name = "Widget Corps Internal Applications"
#   session_duration = "24h"
#   ui_read_only_toggle_reason = "Temporarily turn off the UI read only lock to make a change via the UI"
#   user_seat_expiration_inactive_time = "730h"
#   warp_auth_session_duration = "24h"
# }

resource "cloudflare_zero_trust_gateway_logging" "logging" {
  account_id = var.account_id
  redact_pii = false
  settings_by_rule_type = {
    dns = {
      log_all    = true
      log_blocks = true
    }
    http = {
      log_all    = true
      log_blocks = true
    }
    l4 = {
      log_all    = true
      log_blocks = true
    }
  }
}