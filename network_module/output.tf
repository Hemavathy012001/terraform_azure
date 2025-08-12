#vnet_ids
output "vnet_id" {
    value = [for vnet in azurerm_virtual_network.azpractice_virtual_network :vnet.id]
}

#subnet_ids
output "subnet_ids" {
  value = { for key, subnet in azurerm_subnet.azpractice_azurerm_subnet : key => subnet.id }
}
