output "list_id" {
    value = cloudflare_zero_trust_list.amazon_ipv4.id
}

output "traffic_selector" {
    value = "\"${cloudflare_zero_trust_list.amazon_ipv4.id}\""
}