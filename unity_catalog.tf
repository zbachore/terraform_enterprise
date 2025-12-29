###############################################################################
# 2) Access Connector (Managed Identity) for Unity Catalog storage access
###############################################################################
resource "azurerm_databricks_access_connector" "uc" {
  name                = "${var.company}-${var. environment}-uc-ac"
  resource_group_name = azurerm_resource_group. rg.name
  location            = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

###############################################################################
# 3) RBAC: Allow the connector to read/write blobs in the container
###############################################################################
resource "azurerm_role_assignment" "uc_storage_blob_contrib" {
  scope                = azurerm_storage_container. skylink.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.uc.identity[0]. principal_id
}

###############################################################################
# 4) Unity Catalog: Storage Credential + External Location
###############################################################################
resource "databricks_storage_credential" "uc" {
  name    = "${var.company}_${var. environment}_uc_cred"
  comment = "UC storage credential backed by Databricks Access Connector"

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.uc.id
  }
}

locals {
  skylink_container_root  = "abfss://${azurerm_storage_container.skylink.name}@${azurerm_storage_account. datalake.name}.dfs.core.windows.net/"
  
  # CORRECT - references skylink_container_root
  uc_root_folder = local. skylink_container_root
}

resource "databricks_external_location" "uc_root" {
  name            = "${var.company}_${var.environment}_uc_root"
  url             = local.uc_root_folder
  credential_name = databricks_storage_credential. uc.name
  comment         = "UC external location under ADLS container skylink"

  depends_on = [azurerm_role_assignment.uc_storage_blob_contrib]
}

###############################################################################
# 7) Grant permissions on External Location
###############################################################################
resource "databricks_grants" "external_location_full_control" {
  depends_on = [databricks_external_location. uc_root]

  external_location = databricks_external_location.uc_root.name

  grant {
    principal = databricks_service_principal.svc_sp.application_id
    privileges = [
      "READ_FILES",
      "WRITE_FILES",
      "CREATE_EXTERNAL_TABLE",
      "ALL_PRIVILEGES" # Remove this later.
    ]
  }
}

