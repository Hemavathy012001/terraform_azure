
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
  ["azpractice_fe_subnet", "azpractice_be_subnet", "azpractice_db_subnet"]
]
subnet_cidr = [
  # ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  ["10.0.1.0/24","10.0.2.0/24"]
]

