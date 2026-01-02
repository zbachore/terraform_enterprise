subscription_id = "172a6bd6-5216-4d6b-9306-f4e719307cea"

company     = "skylink"
environment = "u"
location    = "eastus2"
sku         = "premium"


tags = {
  Company     = "skylink"
  Environment = "uat"
  ManagedBy   = "terraform"
}
kv_admin_group_name = "skylink-kv-admins"
github_org  = "zbachore"
github_repo = "dab_project"
uc_catalog_name = "citibike_test"
uc_metastore_id = "3055055b-fdf0-451c-b9af-d288a3a2337b"

vnet_address_space            = ["10.1.0.0/16"]
public_subnet_address_prefix  = ["10.1.1.0/24"]
private_subnet_address_prefix = ["10.1.2.0/24"]
public_network_access_enabled = true
storage_public_network_access_enabled = true
no_public_ip = false
network_security_group_rules_required     = "AllRules"
azure_tenant_id = "eea48c57-d343-4618-b12f-b7cb084e8021"
github_environment = "test"
