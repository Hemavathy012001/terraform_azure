
# #routetable for hub
# resource "azurerm_route_table" "hub_route_table" {
#   name                = "hub_route_table"
#   location            = var.location
#   resource_group_name = data.azurerm_resource_group.azpractice_rg.name
#   route {
#     name           = "route_to_internet"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "Internet"
#   }
#   tags = var.tags
# }

locals {
  spoke_names            = ["spoke1_route_table"]
  allowed_address_prefix = ["10.0.1.0/24"]
  subnet_route_table_map = {
    "azpractice_hub_vnet-azpractice_hub_subnet1"     = "hub_route_table"
    "azpractice_spoke_vnet-azpractice_spoke_subnet1" = "spoke1_route_table"
  }
  # route_table_id_lookup = {
  #   hub_route_table = azurerm_route_table.hub_route_table.id
  #   spoke1_route_table = azurerm_route_table.spoke_route_tables[0].id
  # }
}

# #route table for spokes 
# resource "azurerm_route_table" "spoke_route_tables" {
#   count = length(local.spoke_names)
#   name                = element(local.spoke_names,count.index)
#   location            = var.location
#   resource_group_name = data.azurerm_resource_group.azpractice_rg.name
#   route {
#     name           = "example"
#     address_prefix = element(local.allowed_address_prefix,count.index)
#     next_hop_type  = "VnetLocal"
#   }
#   tags = var.tags
# }


# # subnets, route table assoctiation
# resource "azurerm_subnet_route_table_association" "rt_subnet_associations" {
#   for_each = local.subnet_route_table_map
#   subnet_id = module.networking.subnet_ids[each.key]
#   route_table_id = lookup(local.route_table_id_lookup,each.value)
# }
