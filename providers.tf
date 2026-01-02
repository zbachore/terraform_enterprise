terraform {
  backend "azurerm" {}

  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
databricks = {
  source  = "databricks/databricks"
  version = "~> 1.56.0"  # Update from 1.15.0
}
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

provider "azuread" {}

# Databricks provider:
# - Workspace resolved dynamically from the Azure resource ID
# - Auth uses the identity running Terraform (Azure CLI / CI OIDC)
provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace. ws.id
  auth_type                   = "azure-cli"
  azure_tenant_id             = var.azure_tenant_id  # Use variable
}
