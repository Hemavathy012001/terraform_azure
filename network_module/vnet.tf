resource "azurerm_virtual_network" "azpractice_virtual_network" {
  count               = length(var.cidr_range)
  name                = var.vnet_name[count.index]
  location            = data.azurerm_resource_group.azpractice_rg.location
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name
  address_space       = var.cidr_range[count.index]
  tags                = var.tags
}