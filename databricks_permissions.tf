###############################################
# 1) Azure control-plane permission
###############################################

resource "azurerm_role_assignment" "databricks_workspace_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal. svc_sp.object_id
}

###############################################
# 2) Databricks: ensure SP exists in workspace (SCIM)
###############################################

# Create (or manage) the workspace-level Databricks service principal that maps to the Entra app
resource "databricks_service_principal" "svc_sp" {
  application_id = azuread_application.svc_app. client_id
  display_name   = local.app_reg_display_name

  depends_on = [
    azurerm_databricks_workspace.ws,
    azurerm_role_assignment.databricks_workspace_contributor
  ]

  # ADDED: Prevent premature destruction during workspace replacement
  lifecycle {
    create_before_destroy = false
  }
}

###############################################
# 3) Databricks: admins group lookup
###############################################

data "databricks_group" "admins" {
  display_name = "admins"

  depends_on = [
    azurerm_databricks_workspace.ws
  ]
}

###############################################
# 4) Databricks: add SP to admins group
###############################################

resource "databricks_group_member" "workspace_admin_assignment" {
  group_id  = data.databricks_group. admins.id
  member_id = databricks_service_principal.svc_sp.id

  depends_on = [
    databricks_service_principal.svc_sp,
    data.databricks_group.admins  # ADDED: explicit dependency
  ]
}

###############################################################################
# Workspace folder permissions:  /Shared/skylink (not /Shared)
###############################################################################
resource "databricks_directory" "shared_skylink" {
  path = "/Shared/skylink"

  # ADDED: Ensure workspace is ready
  depends_on = [
    azurerm_databricks_workspace.ws,
    databricks_service_principal.svc_sp  # ADDED: wait for SP to exist first
  ]
}

resource "databricks_permissions" "sp_shared_skylink_access" {
  directory_path = databricks_directory.shared_skylink. path

  access_control {
    service_principal_name = databricks_service_principal. svc_sp.application_id
    permission_level       = "CAN_MANAGE"
  }

  # ADDED: Explicit dependency chain
  depends_on = [
    databricks_directory.shared_skylink,
    databricks_service_principal.svc_sp
  ]
}


# The user Terraform is currently authenticated as (via azure-cli)
data "databricks_current_user" "me" {
  depends_on = [
    azurerm_databricks_workspace.ws,
    databricks_service_principal.svc_sp  # ADDED: ensure SP is created first
  ]
}

# Combined grants for both the Terraform-running user and automation SP
# resource "databricks_grants" "metastore_bootstrap" {
#   metastore = var. uc_metastore_id

#   # Grant to the Terraform-running user
#   grant {
#     principal = data.databricks_current_user.me. user_name
#     privileges = [
#       "CREATE_CATALOG",
#       "CREATE_EXTERNAL_LOCATION",
#       "CREATE_STORAGE_CREDENTIAL"
#     ]
#   }

  # Grant to the automation service principal
#   grant {
#     principal = databricks_service_principal.svc_sp.application_id
#     privileges = [
#       "CREATE_CATALOG",
#       "CREATE_EXTERNAL_LOCATION",
#       "CREATE_STORAGE_CREDENTIAL"
#     ]
#   }

#   depends_on = [
#     databricks_service_principal.svc_sp,
#     data.databricks_current_user.me  # ADDED: ensure current user is loaded
#   ]
# }