module "networking" {
  source      = "../network_module"
  location    = var.location
  vnet_name   = var.vnet_name
  cidr_range  = var.cidr_range
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
  tags        = var.tags
}
