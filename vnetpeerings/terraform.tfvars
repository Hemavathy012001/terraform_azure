
#MODULE VALUES

location = "Central India"

#vnet values
cidr_range = [
  ["10.0.1.0/24"], ["10.0.2.0/24"], ["10.0.3.0/24"]
]
vnet_name = ["azpractice_hub_vnet", "azpractice_spoke1_vnet", "azpractice_spoke2_vnet"]

#tags applied for all resources
tags = {
  application = "azpractice"
  environment = "dev"
}

#subnet values
subnet_cidr = [
  ["10.0.1.0/28"],
  ["10.0.2.0/28"],
  ["10.0.3.0/28"]
]

subnet_name = [
  ["azpractice_hub_subnet1"],
  ["azpractice_spoke1_subnet1"],
  ["azpractice_spoke2_subnet1"]
]

subnet_ids = ["azpractice_hub_vnet-azpractice_hub_subnet1", "azpractice_spoke1_vnet-azpractice_spoke1_subnet1", "azpractice_spoke2_vnet-azpractice_spoke2_subnet1"]
vm_names   = ["hubvm", "spoke1vm", "spoke2vm"]

custom_rules = [
  {
    nsg_name                   = "hub"
    name                       = "hub-rule1"
    priority                   = 100
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  },
  {
    nsg_name                   = "spoke1"
    name                       = "spoke1-rule1"
    priority                   = 101
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.2.0/24"

  },
  {
    nsg_name                   = "spoke2"
    name                       = "spoke2-rule1"
    priority                   = 101
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.3.0/24"
  }
]