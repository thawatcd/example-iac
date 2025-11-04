variable "resource_group_name" { type = string }
variable "project_name" { type = string }
variable "env" { type = string }
variable "running_number" { type = number }
variable "location" {
	type    = string
	default = "eastus"
}

variable "sku" {
	type    = string
	default = "S0"
}
