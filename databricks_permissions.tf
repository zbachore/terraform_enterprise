############################################
# 1) Azure control-plane permission
############################################

resource "azurerm_role_assignment" "databricks_workspace_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.svc_sp.object_id
}

############################################
# 2) Databricks: ensure SP exists in workspace (SCIM)
############################################

# Create (or manage) the workspace-level Databricks service principal that maps to the Entra app
resource "databricks_service_principal" "svc_sp" {
  application_id = azuread_application.svc_app.client_id
  display_name   = local.app_reg_display_name

  depends_on = [
    azurerm_databricks_workspace.ws,
    azurerm_role_assignment.databricks_workspace_contributor
  ]
}

############################################
# 3) Databricks: admins group lookup
############################################

data "databricks_group" "admins" {
  display_name = "admins"

  depends_on = [
    azurerm_databricks_workspace.ws
  ]
}

############################################
# 4) Databricks: add SP to admins group
############################################

resource "databricks_group_member" "workspace_admin_assignment" {
  group_id  = data.databricks_group.admins.id
  member_id = databricks_service_principal.svc_sp.id

  depends_on = [
    databricks_service_principal.svc_sp
  ]
}
