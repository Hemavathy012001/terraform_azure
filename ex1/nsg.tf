locals {
  custom_rules_fe = [
    {
        name                       = "fe-rule1"
        priority                   = 100
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "10.0.0.0/16"
    }
  ]
  custom_rules_be = [
    {
        name                       = "be-rule1"
        priority                   = 100
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    },
    {
        name                       = "be-rule2"
        priority                   = 101
        destination_port_range     = "22"
        source_address_prefix      = "10.0.0.0/16"
        destination_address_prefix = "10.0.0.0/16"
    }
  ]
}

#NSG for front_end

resource "azurerm_network_security_group" "fe_azurerm_network_security_group" {
  name                = "fe_azurerm_network_security_group"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name

  dynamic "security_rule" {
    for_each = local.custom_rules_fe
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

#NSG for back_end
resource "azurerm_network_security_group" "be_azurerm_network_security_group" {
  name                = "be_azurerm_network_security_group"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name

  dynamic "security_rule" {
    for_each = local.custom_rules_be
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

#associate nsg with front_end subnet
resource "azurerm_subnet_network_security_group_association" "fe_subnet_network_security_group_association" {
  subnet_id                 = module.networking.subnet_ids["azpractice_vnet-azpractice_fe_subnet"]
  network_security_group_id = azurerm_network_security_group.fe_azurerm_network_security_group.id
}

#associate nsg with back_end subnet
resource "azurerm_subnet_network_security_group_association" "be_subnet_network_security_group_association" {
  subnet_id                 = module.networking.subnet_ids["azpractice_vnet-azpractice_be_subnet"]
  network_security_group_id = azurerm_network_security_group.be_azurerm_network_security_group.id
}