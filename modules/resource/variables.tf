variable "project_name" {
  type = string
  description = "Short project identifier used in resource names. Allowed: alphanumeric and hyphen, 1-16 chars"
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,16}$", var.project_name))
    error_message = "project_name must be 1-16 characters, letters, numbers or hyphen only"
  }
}

variable "env" {
  type = string
  description = "Environment short name (dev/stg/prod). Allowed: lowercase alpha 1-8 chars"
  validation {
    condition     = can(regex("^[a-z0-9]{1,8}$", var.env))
    error_message = "env must be 1-8 lowercase letters or numbers (e.g. dev, sbx, prod)"
  }
}

variable "running_number" {
  type = number
}

variable "location" {
  type    = string
  default = "eastus"
}
