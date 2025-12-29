###############################################################################
# Allow the Terraform execution identity (user, service principal, or CI identity)
# running `terraform apply` to create, update, and delete Key Vault secrets
###############################################################################

resource "azurerm_role_assignment" "terraform_kv_secrets" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}


###############################################################################
# Allow the GitHub OIDC identity (service principal) to read Key Vault secrets
###############################################################################

resource "azurerm_role_assignment" "github_actions_kv_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"

  # Dynamic: the SP Terraform already creates for your app registration
  principal_id = azuread_service_principal.svc_sp.object_id
}
