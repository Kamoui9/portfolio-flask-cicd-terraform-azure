terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  # tenant_id = "00000000-0000-0000-0000-000000000000"
}

provider "github" {
  token = var.gh_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}