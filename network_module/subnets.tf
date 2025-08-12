/*
        [
            [
                {
                    subnet_cidr = subnet_cidr
                    subnet_name = subnet_name
                    vnet_name = vnet_name
                }
            ]
        ]
*/

#flattening will convert to -

/*
        [
            {
                subnet_cidr = subnet_cidr
                subnet_name = subnet_name
                vnet_name = vnet_name
            },
            {
                subnet_cidr = subnet_cidr
                subnet_name = subnet_name
                vnet_name = vnet_name
            }
        ]
*/

locals {
  subnets = flatten([
    for vnet_index, subnet in var.subnet_cidr : [
      for subnet_index, sub_cidr in subnet : {
        subnet_cidr = var.subnet_cidr[vnet_index][subnet_index]
        subnet_name = var.subnet_name[vnet_index][subnet_index]
        vnet_name   = var.vnet_name[vnet_index]
      }
    ]
    ]
  )
}

  # In for_each terraform accepts map/set of string so we are converting flattented list to map, the output for the below will be like 
  
    # {
    #     "vnet_name-subnet_name" = {
    #       subnet_cidr = subnet_cidr
    #       subnet_name = subnet_name
    #       vnet_name   = vnet_name
    #     }
    # }

resource "azurerm_subnet" "azpractice_azurerm_subnet" {
  #converstion to map 
  depends_on = [ azurerm_virtual_network.azpractice_virtual_network ]
  for_each = {
    for values in local.subnets : "${values.vnet_name}-${values.subnet_name}" => values
  }
  resource_group_name  = data.azurerm_resource_group.azpractice_rg.name
  virtual_network_name = each.value.vnet_name
  name                 = each.value.subnet_name
  address_prefixes     = [each.value.subnet_cidr]

}

#or 

# resource "azurerm_subnet" "azpractice_azurerm_subnet" {
#   count                = length(local.subnets)
#   depends_on = [ azurerm_virtual_network.azpractice_virtual_network ]
#   resource_group_name  = data.azurerm_resource_group.azpractice_rg.name
#   virtual_network_name = local.subnets[count.index].vnet_name
#   name                 = local.subnets[count.index].subnet_name
#   address_prefixes     = [local.subnets[count.index].subnet_cidr]
# }

