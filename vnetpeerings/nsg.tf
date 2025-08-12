locals {
  ## Build map from nsg rules
  nsg_definitions = {
    for nsg in distinct([for r in var.custom_rules : r.nsg_name]) :
    nsg => {
      subnet_id = "azpractice_${nsg}_vnet-azpractice_${nsg}_subnet1"
      rules     = [for r in var.custom_rules : r if r.nsg_name == nsg]
    }
  }
}

#NSG for back_end
resource "azurerm_network_security_group" "azpractice_azurerm_network_security_group" {
  for_each            = local.nsg_definitions
  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name

  dynamic "security_rule" {
    for_each = each.value.rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
  tags = var.tags
}

#subnet network security group association
resource "azurerm_subnet_network_security_group_association" "azpractice_subnet_network_security_group_association" {
  for_each                  = local.nsg_definitions
  subnet_id                 = module.networking.subnet_ids[each.value.subnet_id]
  network_security_group_id = azurerm_network_security_group.azpractice_azurerm_network_security_group[each.key].id
}

