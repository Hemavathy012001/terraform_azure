
# Network interface cards for VMs
resource "azurerm_network_interface" "azpractice_nic" {
  count               = length(var.subnet_ids)
  name                = "${element(var.subnet_ids, count.index)}-nic"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.networking.subnet_ids[var.subnet_ids[count.index]]
    private_ip_address_allocation = "Dynamic"
    # Attach public IP only for NIC in "hub" subnet
    public_ip_address_id = can(regex("hub", var.subnet_ids[count.index])) ? azurerm_public_ip.hub_azpractice_public_ip.id : null
  }
}

# Public IP 
resource "azurerm_public_ip" "hub_azpractice_public_ip" {
  name                = "azpractice_public_ip"
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name
  location            = var.location
  allocation_method   = "Static"
}

# VMs 
resource "azurerm_linux_virtual_machine" "azpractice_virtual_machines" {
  count               = length(var.subnet_ids)
  name                = var.vm_names[count.index]
  resource_group_name = data.azurerm_resource_group.azpractice_rg.name
  location            = var.location

  size                            = "Standard_B1ls"
  disable_password_authentication = false
  admin_username                  = "azureuseruser"
  admin_password                  = "azureuser@123"

  network_interface_ids = [
    azurerm_network_interface.azpractice_nic[count.index].id
  ]

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
  tags = var.tags
}


