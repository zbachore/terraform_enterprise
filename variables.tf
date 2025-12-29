variable "company" {
  description = "Company or organization prefix used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment code (d = dev, u = uat, p = prod)."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
}

variable "subscription_id" {
  description = "Azure subscription ID Terraform should use."
  type        = string
}

variable "sku" {
  description = "Databricks workspace SKU"
  type        = string

  validation {
    condition     = contains(["standard", "premium"], var.sku)
    error_message = "sku must be either 'standard' or 'premium'."
  }
}

variable "app_reg_suffix" {
  type        = string
  description = "Suffix part of the app registration name"
  default     = "svc-principal"
}

locals {
  common_tags = {
    Application = "skylink"
    ManagedBy   = "terraform"
    Environment = var.environment
  }
}

variable "kv_admin_group_name" {
  type        = string
  description = "Entra ID group display name to grant Key Vault Administrator on this vault"
}

variable "uc_catalog_name" {
  type        = string
  description = "Unity Catalog catalog name to create/manage"
}

# Optional: container name for UC managed storage
variable "uc_container_name" {
  type        = string
  description = "Container name for UC managed storage"
  default     = "unity-catalog"
}

variable "uc_metastore_id" {
  type        = string
  description = "Unity Catalog metastore ID (GUID)."
}


