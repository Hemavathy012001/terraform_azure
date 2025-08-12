
#MODULE VALUES
# name     = "azpractice"
location = "Central India"

#vnet values
cidr_range = [
  ["10.0.0.0/16"]
]
vnet_name = ["azpractice_vnet"]

#tags applied for all resources
tags = {
  application = "azpractice"
  environment = "dev"
}

#subnet values
subnet_name = [
  # ["azpractice_fe_subnet", "azpractice_be_subnet", "azpractice_db_subnet"]
  ["azpractice_fe_subnet", "azpractice_be_subnet"]
]
subnet_cidr = [
  # ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  ["10.0.1.0/24", "10.0.2.0/24"]
]

#Ex1 Values 
fe_route_table_name = "fe_route_table"
be_route_table_name = "be_route_table"

#VM names 
vm_names = [ "publicvm","privatevm" ]

#network interface card names
nic_names = [ "public_nic","private_nic" ]