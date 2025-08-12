# resource "azurerm_resource_group" "azpractice_rg" {
#   name     = var.name
#   location = var.location
# }

data "azurerm_resource_group" "azpractice_rg" {
  name     = "azpractice"
}