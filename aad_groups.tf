data "azuread_group" "kv_admins" {
  display_name = var.kv_admin_group_name
}
