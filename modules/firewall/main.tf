terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

locals {
  cloudflare_hostnames = [
    "cloudflare.com",
    "dash.cloudflare.com",
    "one.dash.cloudflare.com",
    "cloudflare-dns.com",
    "engage.cloudflareclient.com",
    "zero-trust-client.cloudflareclient.com",
    "connectivity.cloudflareclient.com",
    "time.cloudflare.com",
    "${var.team}.cloudflareaccess.com",
    "${var.team}.cloudflare-gateway.com"
  ]

  cloudflare_ip = [
    ## WARP Firewall ##
    ## https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/deployment/firewall/ ##

    # WARP Client Orchestration API
    "162.159.137.105",
    "162.159.138.105",
    "2606:4700:7::a29f:8969",
    "2606:4700:7::a29f:8a69",

    # DOH IP
    "162.159.36.1",
    "162.159.46.1",
    "2606:4700:4700::1111",
    "2606:4700:4700::1001",

    # WARP Ingress WireGuard
    "162.159.193.0/24",
    "2606:4700:100::/48",

    # WARP Ingress MASQUE
    "162.159.197.0/24",
    "2606:4700:102::/48",

    # Engage
    "162.159.197.3",
    "2606:4700:102::3",

    # WARP Client Connectivity
    "162.159.197.4",
    "2606:4700:102::4"
  ]
}

data "cloudflare_accounts" "this" {
  name = "Siguiente"
}

resource "cloudflare_zero_trust_list" "cloudflare" {
  name = "Cloudflare Hostnames"
  type = "DOMAIN"
  account_id = var.account
  items = [
    for s in local.cloudflare_hostnames : {
      value = s
    }
  ]
}

resource "cloudflare_zero_trust_list" "cloudflare_ip" {
  name = "Cloudflare IP"
  
  type = "IP"
  account_id = var.account
  items = [
    for s in local.local.cloudflare_ip : {
      value = s
    }
  ]
}
