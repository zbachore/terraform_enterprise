locals {
  app_reg_display_name = "${var.company}-${var.environment}-${var.app_reg_suffix}"
}

resource "azuread_application" "svc_app" {
  display_name = local.app_reg_display_name

  # Keep it simple at first. Add redirect URIs / API permissions later if needed.
}

resource "azuread_service_principal" "svc_sp" {
  client_id = azuread_application.svc_app.client_id
}

# Create Service Principal Secret in Microsoft Entra ID
resource "azuread_application_password" "svc_secret" {
  application_id    = azuread_application.svc_app.id
  display_name      = "terraform-generated"
  end_date_relative = "2160h" # 90 days
}

# Store Service Principal Secret in Key Vault
resource "azurerm_key_vault_secret" "svc_app_secret" {
  name         = "${var.company}-${var.environment}-svc-principal-secret"
  value        = azuread_application_password.svc_secret.value
  key_vault_id = azurerm_key_vault.kv.id

  tags = local.common_tags

  depends_on = [
    azurerm_role_assignment.terraform_kv_secrets
  ]
}
