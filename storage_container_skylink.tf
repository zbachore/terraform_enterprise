resource "azurerm_storage_container" "skylink" {
  name                  = "skylink"
  storage_account_id    = azurerm_storage_account.datalake.id
  container_access_type = "private"
}
