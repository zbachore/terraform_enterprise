

resource "azurerm_role_assignment" "kv_admin_group" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.kv_admins.object_id
}
