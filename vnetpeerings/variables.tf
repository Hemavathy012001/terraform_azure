
#location
variable "location" {
  type = string
  validation {
    condition     = contains(["Central India"], var.location)
    error_message = "Only region Central India is allowed"
  }
}

#vnet vars
variable "cidr_range" {
  type = list(list(string))
}

#vnet_name
variable "vnet_name" {
  type = list(string)
}

#tags applied for all resources
variable "tags" {
  type = object({
    application = string
    environment = string
  })
}

#subnet details
variable "subnet_cidr" {
  type = list(list(string))
}

#subnet_name and id's
variable "subnet_name" {
  type = list(list(string))
}

variable "subnet_ids" {
  type = list(string)
}

#vmnames
variable "vm_names" {
  type = list(string)
}

#custom rules for nsg
variable "custom_rules" {
  type = list(object(
    {
      nsg_name                   = string
      name                       = string
      priority                   = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }
  ))
}