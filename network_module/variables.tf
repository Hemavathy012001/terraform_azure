#resource group vars
# variable "name" {
#   type = string
# }

variable "location" {
  type = string
  validation {
    condition = contains(["Central India"], var.location)
    error_message = "Only region Central India is allowed"
  }
}

#vnet vars
variable "cidr_range" {
  type = list(list(string))
}

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

#subnet name
variable "subnet_cidr" {
  type = list(list(string))
}
variable "subnet_name" {
  type = list(list(string))
}
