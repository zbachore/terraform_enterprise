# Virtual Network for Databricks
resource "azurerm_virtual_network" "databricks" {
  name                = "${var. company}-${var.environment}-${var.location}-vnet"
  address_space       = var. vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}

# Public Subnet (for Databricks control plane communication)
resource "azurerm_subnet" "public" {
  name                 = "${var.company}-${var.environment}-public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.databricks.name
  address_prefixes     = var. public_subnet_address_prefix

  delegation {
    name = "databricks-delegation-public"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Private Subnet (for Databricks cluster nodes)
resource "azurerm_subnet" "private" {
  name                 = "${var.company}-${var.environment}-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.databricks. name
  address_prefixes     = var.private_subnet_address_prefix

  delegation {
    name = "databricks-delegation-private"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Network Security Group for Databricks
resource "azurerm_network_security_group" "databricks" {
  name                = "${var.company}-${var.environment}-${var.location}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group. rg.name

  tags = local.common_tags
}

# Associate NSG with Public Subnet
resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.databricks.id
}

# Associate NSG with Private Subnet
resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet. private.id
  network_security_group_id = azurerm_network_security_group.databricks.id
}