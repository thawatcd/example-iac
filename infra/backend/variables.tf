variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "storage_account_name" {
  type = string
}

variable "container_name" {
  type = string
  default = "tfstate"
}

variable "sku_tier" {
  type    = string
  default = "Standard"
}

variable "sku_replication" {
  type    = string
  default = "LRS"
}

variable "soft_delete_days" {
  type    = number
  default = 7
}

variable "tags" {
  type = map(string)
  default = {}
}
