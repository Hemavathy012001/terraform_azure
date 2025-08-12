
#peering networks
# data blocks to fetch hub and spoke vnets ids
# data "azurerm_virtual_network" "hub_vnet" {
#   name                = var.vnet_name[0] # assuming [0] is hub
#   resource_group_name = data.azurerm_resource_group.azpractice_rg.name
# }

# data "azurerm_virtual_network" "spoke1_vnet" {
#   name                = var.vnet_name[1] # assuming [1] is spoke
#   resource_group_name = data.azurerm_resource_group.azpractice_rg.name
# }

# data "azurerm_virtual_network" "spoke2_vnet" {
#   name                = var.vnet_name[2] # assuming [1] is spoke
#   resource_group_name = data.azurerm_resource_group.azpractice_rg.name
# }

locals {
  /*
    hub    = "azpractice_hub_vnet"
    spoke1 = "azpractice_spoke1_vnet"
    spoke2 = "azpractice_spoke2_vnet"
  */
  vnet_map = {
    for name in var.vnet_name :
    regex("[^_]+_(hub|spoke1|spoke2)_.*", name)[0] => name
  }

  peerings = {
    "peerhubtospoke1" = {
        src = "hub", dest="spoke1"
    }
    "peerspoke1tohub" = {
         src = "spoke1", dest="hub"
    }
    "peerhubtospoke2" = {
         src = "hub", dest="spoke2"
    }
    "peerspoke2tohub" = {
        src = "spoke2", dest="hub"
    }
  }
}

data "azurerm_virtual_network" "vnets" {
    for_each = local.vnet_map
    name = each.value
    resource_group_name = data.azurerm_resource_group.azpractice_rg.name
}

resource "azurerm_virtual_network_peering" "hub_to_spoke_vnet_peerings" {
  for_each = local.peerings
  name                         = each.key
  resource_group_name          = data.azurerm_resource_group.azpractice_rg.name
  virtual_network_name         = "azpractice_${each.value.src}_vnet"
  remote_virtual_network_id    = data.azurerm_virtual_network.vnets[each.value.dest].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# resource "azurerm_virtual_network_peering" "hub_to_spoke1_vnet_peering" {
#   name                         = "peerhubtospoke1"
#   resource_group_name          = data.azurerm_resource_group.azpractice_rg.name
#   virtual_network_name         = var.vnet_name[0]
#   remote_virtual_network_id    = data.azurerm_virtual_network.spoke_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = false
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# resource "azurerm_virtual_network_peering" "spoke1_to_hub_vnet_peering" {
#   name                         = "peerspoke1tohub"
#   resource_group_name          = data.azurerm_resource_group.azpractice_rg.name
#   virtual_network_name         = var.vnet_name[1]
#   remote_virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = false
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# resource "azurerm_virtual_network_peering" "spoke2_to_hub_vnet_peering" {
#   name                         = "peerspoke2tohub"
#   resource_group_name          = data.azurerm_resource_group.azpractice_rg.name
#   virtual_network_name         = var.vnet_name[2]
#   remote_virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = false
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }