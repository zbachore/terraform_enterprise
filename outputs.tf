output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.rg.name
}

output "databricks_workspace_name" {
  description = "Databricks workspace name."
  value       = azurerm_databricks_workspace.ws.name
}


