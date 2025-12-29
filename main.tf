resource "azurerm_resource_group" "rg" {
  name     = "${var.company}-${var.environment}-${var.location}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_databricks_workspace" "ws" {
  name                = "${var.company}-${var.environment}-${var.location}-dbx-ws"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku  = var.sku
  tags = local.common_tags
}

resource "azurerm_storage_account" "datalake" {
  name                     = "${var.company}${var.environment}${var.location}datalake"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true

  tags = local.common_tags
}

resource "azurerm_key_vault" "kv" {
  name                = "${var.company}-${var.environment}-${var.location}-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true

  tags = local.common_tags
}

resource "azurerm_data_factory" "example" {
  name                = "${var.company}-${var.environment}-${var.location}-adf"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}

data "azurerm_client_config" "current" {}

############################################
# Outputs (required for Databricks provider)
############################################

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.ws.id
}