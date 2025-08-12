
#routetable for front_end
resource "azurerm_route_table" "fe_route_table" {
  name                = var.fe_route_table_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name
  route {
    name           = "fe_route_to_internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
  tags = var.tags
}


#route table for back_end 
resource "azurerm_route_table" "be_route_table" {
  name                = var.be_route_table_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name
  route {
    name           = "acceptanceTestRoute1"
    address_prefix = "10.0.0.0/16"
    next_hop_type  = "VnetLocal"
  }
  tags = var.tags
}

# front_end subnet, route table assoctiation
resource "azurerm_subnet_route_table_association" "front_end_rt_sub_associate" {
  subnet_id      = module.networking.subnet_ids["azpractice_vnet-azpractice_fe_subnet"]
  route_table_id = azurerm_route_table.fe_route_table.id
}

# back_end subnet, route table assoctiation
resource "azurerm_subnet_route_table_association" "back_end_rt_sub_associate" {
  subnet_id      = module.networking.subnet_ids["azpractice_vnet-azpractice_be_subnet"]
  route_table_id = azurerm_route_table.be_route_table.id
}