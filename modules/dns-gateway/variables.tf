variable "account" {
    type = string
}

variable "ip_allow_lists" {
    type = list(string)
}

variable "domain_block_lists" {
    type = list(string)
}