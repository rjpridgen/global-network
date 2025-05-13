terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }
  }
}

data "http" "github_meta" {
  url = "https://api.github.com/meta"
}

data "http" "amazon_web_services" {
  for_each = toset([
    "https://configuration.private-access.console.amazonaws.com/us-east-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/us-east-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/us-west-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-northeast-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-northeast-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-southeast-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-southeast-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-south-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/ap-south-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/ca-central-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-central-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-west-1.config.json",
    "https://configuration.private-access.console.amazonaws.com/eu-west-2.config.json",
    "https://configuration.private-access.console.amazonaws.com/il-central-1.config.json"
  ])
  url = each.value
}

locals {
  aws_data = [ for response in data.http.amazon_web_services : jsondecode(response.body).ServiceDetails ]

  amazon_web_services_responses = [
     for response in local.aws_data : {
				ipv4 = flatten([for service in response : service.PrivateIpv4DnsNames])
     }
   ]

  github_api_metadata = jsondecode(data.http.github_meta.body)
}

resource "cloudflare_zero_trust_list" "github" {
  for_each = toset(["web", "api", "git", "packages", "pages", "importer", "codespaces", "copilot"])
  name = "Github ${each.value}"
  type = "IP"
  account_id = var.account
  items = [
    for ip in local.github_api_metadata[each.value]: {
      value = ip
    }
  ]
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
    for s in local.cloudflare_ip : {
      value = s
    }
  ]
}
