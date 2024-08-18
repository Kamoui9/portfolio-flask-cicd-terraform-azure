resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}"
  location = "francecentral"
}


############################
# APP

resource "azurerm_service_plan" "asp" {
  name                = "asp-${var.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "alwa" {
  name                = "alwa-${var.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  app_settings = { "SCM_DO_BUILD_DURING_DEPLOYMENT" = 1 }

  site_config {
    application_stack {
      python_version = 3.11
    }
  }
}

resource "azurerm_app_service_source_control" "aasc" {
  app_id   = azurerm_linux_web_app.alwa.id
  repo_url = "https://github.com/${var.repo_owner}/${var.repo_name}"
  branch   = var.repo_branch
}
resource "azurerm_source_control_token" "asct" {
  type  = "GitHub"
  token = var.gh_token
}

############################
# DNS

resource "cloudflare_record" "TXT" {
  zone_id = var.zone_id
  name    = "asuid.${var.subdomainonly}"
  content = azurerm_linux_web_app.alwa.custom_domain_verification_id
  type    = "TXT"
  ttl     = 3600
}

resource "cloudflare_record" "CNAME" {
  zone_id = var.zone_id
  name    = var.subdomainonly
  content = azurerm_linux_web_app.alwa.default_hostname
  type    = "CNAME"
  ttl     = 3600
}

resource "azurerm_app_service_custom_hostname_binding" "aaschb" {
  hostname            = var.subdomain
  app_service_name    = azurerm_linux_web_app.alwa.name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [
    cloudflare_record.TXT,
    cloudflare_record.CNAME
  ]
}

resource "azurerm_app_service_managed_certificate" "aasmc" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.aaschb.id
}

resource "azurerm_app_service_certificate_binding" "aascb" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.aaschb.id
  certificate_id      = azurerm_app_service_managed_certificate.aasmc.id
  ssl_state           = "SniEnabled"
}

############################
# CI/CD env var & secrets

data "azuread_client_config" "current" {}

resource "azuread_application" "app" {
  display_name = "app-${var.name}"
  owners       = [data.azuread_client_config.current.object_id]
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# service principal bc the gh runner need to authenticate
resource "azuread_service_principal" "app" {
  application_id               = azuread_application.app.application_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.app.object_id
}

resource "azurerm_role_assignment" "role" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.app.object_id

  depends_on = [
    azuread_service_principal.app
  ]
}

data "azurerm_subscription" "current" {}

data "github_repository" "repo" {
  full_name = "${var.repo_owner}/${var.repo_name}"
}

resource "github_repository_environment" "repo_environment" {
  repository  = data.github_repository.repo.name
  environment = "prod"
}

# ENV var
resource "github_actions_environment_variable" "env-var-APP_NAME" {
  repository    = data.github_repository.repo.name
  environment   = github_repository_environment.repo_environment.environment
  variable_name = "APP_NAME"
  value         = "alwa-${var.name}"
}

resource "github_actions_secret" "secrets-var-AZURE_CLIENT_ID" {
  repository      = data.github_repository.repo.name
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azuread_application.app.application_id
}
resource "github_actions_secret" "secrets-var-AZURE_CLIENT_SECRET" {
  repository      = data.github_repository.repo.name
  secret_name     = "AZURE_CLIENT_SECRET"
  plaintext_value = azuread_service_principal_password.app.value
}
resource "github_actions_secret" "secrets-var-AZURE_SUBSCRIPTION_ID" {
  repository      = data.github_repository.repo.name
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = local.last_element_sub
}
locals {
  split_list       = split("/", data.azurerm_subscription.current.id)
  last_element_sub = element(local.split_list, length(local.split_list) - 1)
}

# SECRETS var
resource "github_actions_secret" "secrets-var-AZURE_TENANT_ID" {
  repository      = data.github_repository.repo.name
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = azuread_service_principal.app.application_tenant_id
}