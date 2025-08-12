locals {
  flat_subnet_names = flatten(var.subnet_name)
  subnet_ids = [module.networking.subnet_ids["azpractice_vnet-azpractice_fe_subnet"],module.networking.subnet_ids["azpractice_vnet-azpractice_be_subnet"]]
}

# Network interface cards for VMs
resource "azurerm_network_interface" "azpractice_nic" {
  count = length(local.flat_subnet_names)
  name                = element(var.nic_names,count.index)
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(local.subnet_ids,count.index)
    private_ip_address_allocation = "Dynamic"
    # Attach public IP only for NIC in "fe" subnet
    public_ip_address_id = can(regex("fe", local.flat_subnet_names[count.index])) ? azurerm_public_ip.fe_azpractice_public_ip.id : null
  }
}

# VMs 
resource "azurerm_linux_virtual_machine" "azpractice_virtual_machines" {
  count = length(local.flat_subnet_names)
  name                = element(var.vm_names, count.index)
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name
  location            = var.location

  size = "Standard_B1ls"
  disable_password_authentication = false
  admin_username                  = "adminuser"
  admin_password                  = "mypassword123!"

  network_interface_ids = [
    azurerm_network_interface.azpractice_nic[count.index].id
  ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags =  var.tags
}

# Public IP 
resource "azurerm_public_ip" "fe_azpractice_public_ip" {
  name                = "azpractice_public_ip"
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name
  location            = var.location
  allocation_method   = "Static"
}
