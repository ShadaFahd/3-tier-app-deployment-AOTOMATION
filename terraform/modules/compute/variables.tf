variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "frontend_subnet_id" {
  type = string
  default     = null
}

variable "backend_subnet_id" {
  type = string
}

variable "appgateway_subnet_id" {
  type = string
}

variable "control_subnet_id" {
  type = string
}

variable "backend_pool_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vm_size" {
  type = string
}

