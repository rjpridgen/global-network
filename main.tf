terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 5.3.0"
    }
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 1.2"
}

provider "google" {
  project    = var.gcp_project_id
}

data "cloudflare_account" "this" {
  filter = {
    name = "Siguiente"
  }
}

resource "cloudflare_zero_trust_organization" "org" {
  account_id = data.cloudflare_account.this.account_id
  allow_authenticate_via_warp = true
  auth_domain = "test.cloudflareaccess.com"
  auto_redirect_to_identity = true
  custom_pages = {
    forbidden = "699d98642c564d2e855e9661899b7252"
    identity_denied = "699d98642c564d2e855e9661899b7252"
  }
  is_ui_read_only = true
  login_design = {
    background_color = "#c5ed1b"
    footer_text = "This is an example description."
    header_text = "This is an example description."
    logo_path = "https://example.com/logo.png"
    text_color = "#c5ed1b"
  }
  name = "Widget Corps Internal Applications"
  session_duration = "24h"
  ui_read_only_toggle_reason = "Temporarily turn off the UI read only lock to make a change via the UI"
  user_seat_expiration_inactive_time = "730h"
  warp_auth_session_duration = "24h"
}
