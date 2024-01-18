variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "public_ip_address_id" {
  type    = string
  default = null
}

variable "name" {
  type        = string
  description = "Name of the VM"
}

variable "size" {
  type    = string
  default = "Standard_A2_v2"
}

variable "ssh_key" {
  type = string
}

variable "user_data" {
  type = string
}
