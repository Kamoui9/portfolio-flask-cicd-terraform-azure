variable "gh_token" {
  type      = string
  sensitive = true
}

variable "name" {
  type = string
}

variable "repo_owner" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "repo_branch" {
  type = string
}

variable "cloudflare_api_token" {
  sensitive = true
  type      = string
}

variable "zone_id" {
  sensitive = true
  type      = string
}

variable "account_id" {
  sensitive = true
  type      = string
}

variable "domain" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "subdomainonly" {
  type = string
}