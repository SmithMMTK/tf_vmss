variable "rg_name" {
  default = "azVMSS-01"
}
variable "location" {
  default     = "southeastasia"
}

variable "vnet_name" {
  default = "myVNET"
}
variable "vnet_address" {
  default = "10.0.0.0/16"
}
variable "subnet_name1" {
  default = "subnet1"
}
variable "subnet_name1_address" {
  default = "10.0.0.0/24"
}
variable "subnet_name2" {
  default = "subnet2"
}
variable "subnet_name2_address" {
  default = "10.0.1.0/24"
}

variable "subnet_name3" {
  default = "subnet3"
}
variable "subnet_name3_address" {
  default = "10.0.2.0/24"
}
