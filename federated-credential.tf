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

resource "azuread_application_federated_identity_credential" "github_actions_env" {
  # Dynamic reference to the app registration you already create in app_registration.tf
  application_id = azuread_application.svc_app.id

  display_name = "gha-${var.github_repo}-${var.environment}"
  description  = "GitHub Actions OIDC for ${var.github_org}/${var.github_repo} env=${var.environment}"

  issuer    = "https://token.actions.githubusercontent.com"
  audiences = ["api://AzureADTokenExchange"]

  # GitHub Environment-based subject (matches GitHub Environments: dev/uat/prd)
  subject = "repo:${var.github_org}/${var.github_repo}:environment:${var.environment}"
}
