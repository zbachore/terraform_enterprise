###############################################################################
# GitHub Actions OIDC Federated Credential (Environment-based)
# Uses the app registration Terraform already creates: azuread_application.svc_app
###############################################################################

# Add these variables (if you already have them in variables.tf, remove duplicates)
variable "github_org" {
  type        = string
  description = "GitHub org/owner that owns the repo."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name (without org)."
}

variable "github_environment" {
  type        = string
  description = "GitHub environment name for OIDC (overrides var.environment if different from Azure naming)"
  default     = null
}

resource "azuread_application_federated_identity_credential" "github_actions_env" {
  # Dynamic reference to the app registration you already create in app_registration.tf
  application_id = azuread_application.svc_app.id

  display_name = "gha-${var.github_repo}-${coalesce(var.github_environment, var.environment)}"
  description  = "GitHub Actions OIDC for ${var.github_org}/${var.github_repo} env=${coalesce(var.github_environment, var.environment)}"

  issuer    = "https://token.actions.githubusercontent.com"
  audiences = ["api://AzureADTokenExchange"]

  # GitHub Environment-based subject (matches GitHub Environments: test/prd)
  # Uses github_environment if set, otherwise falls back to environment variable
  subject = "repo:${var.github_org}/${var.github_repo}:environment:${coalesce(var.github_environment, var.environment)}"
}