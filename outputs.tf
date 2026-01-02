output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.rg.name
}

output "databricks_workspace_name" {
  description = "Databricks workspace name."
  value       = azurerm_databricks_workspace.ws.name
}

# Network Outputs
output "vnet_id" {
  value       = azurerm_virtual_network.databricks.id
  description = "ID of the Databricks virtual network"
}

output "vnet_name" {
  value       = azurerm_virtual_network.databricks.name
  description = "Name of the Databricks virtual network"
}

output "public_subnet_id" {
  value       = azurerm_subnet.public.id
  description = "ID of the public subnet"
}

output "private_subnet_id" {
  value       = azurerm_subnet.private. id
  description = "ID of the private subnet"
}

output "nsg_id" {
  value       = azurerm_network_security_group.databricks.id
  description = "ID of the network security group"
}

output "databricks_workspace_url" {
  value       = "https://${azurerm_databricks_workspace.ws.workspace_url}/"
  description = "URL of the Databricks workspace"
}
